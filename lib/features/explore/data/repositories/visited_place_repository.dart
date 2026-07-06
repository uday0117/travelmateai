import 'package:isar/isar.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/explore/data/datasources/visited_place_remote_datasource.dart';
import 'package:travelmateai/features/explore/data/models/visited_place_isar_model.dart';
import 'package:travelmateai/features/explore/domain/entities/visited_place.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';

class VisitedPlaceRepository {
  VisitedPlaceRepository(
    this._db, {
    required NetworkInfo networkInfo,
    required VisitedPlaceRemoteDataSource remote,
  })  : _network = networkInfo,
        _remote = remote;

  final DatabaseService _db;
  final NetworkInfo _network;
  final VisitedPlaceRemoteDataSource _remote;

  Future<List<VisitedPlace>> getAll(String userId) async {
    final isar = _db.isar;
    if (isar == null) return [];
    final models = await isar.visitedPlaceIsarModels
        .filter()
        .userIdEqualTo(userId)
        .sortByVisitedAtDesc()
        .findAll();
    return models.where((m) => !m.isDeleted).map((m) => m.toEntity()).toList();
  }

  Future<void> recordFromCompletedTrips(String userId, List<Trip> trips) async {
    final isar = _db.isar;
    if (isar == null) return;

    final completed = trips.where((t) => t.status == TripStatus.completed);
    final toSync = <VisitedPlace>[];
    await isar.writeTxn(() async {
      for (final trip in completed) {
        final parts = trip.destination.split(',');
        final place = VisitedPlace(
          id: '${trip.id}_${trip.destination.hashCode}',
          userId: userId,
          name: parts.first.trim(),
          country: parts.length > 1 ? parts.last.trim() : parts.first.trim(),
          tripId: trip.id,
          visitedAt: trip.endDate,
          syncStatus: SyncStatus.pending,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await isar.visitedPlaceIsarModels.put(VisitedPlaceIsarModel.fromEntity(place));
        toSync.add(place);
      }
    });
    for (final place in toSync) {
      await _trySync(place);
    }
  }

  Future<void> sync(String userId) async {
    if (!await _network.isConnected) return;
    final isar = _db.isar;
    if (isar == null) return;

    final pending = await isar.visitedPlaceIsarModels
        .filter()
        .userIdEqualTo(userId)
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
    for (final m in pending) {
      final place = m.toEntity();
      try {
        if (place.isDeleted) {
          await _remote.delete(place.id);
        } else {
          await _remote.upsert(place);
        }
        await _markSynced(place.id);
      } catch (e, st) {
        AppLogger.warning('Visited place sync failed for ${place.id}', e, st);
      }
    }

    final remote = await _remote.fetch(userId);
    await isar.writeTxn(() async {
      for (final place in remote) {
        await isar.visitedPlaceIsarModels.put(VisitedPlaceIsarModel.fromEntity(place));
      }
    });
  }

  Future<void> _markSynced(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m = await isar.visitedPlaceIsarModels.filter().placeIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.syncStatus = SyncStatus.synced;
      await isar.visitedPlaceIsarModels.put(m);
    });
  }

  Future<void> _trySync(VisitedPlace place) async {
    if (!await _network.isConnected) return;
    try {
      if (place.isDeleted) {
        await _remote.delete(place.id);
      } else {
        await _remote.upsert(place);
      }
      await _markSynced(place.id);
    } catch (e, st) {
      AppLogger.warning('Immediate visited place sync failed', e, st);
    }
  }
}
