import 'package:isar/isar.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/explore/data/datasources/travel_stats_remote_datasource.dart';
import 'package:travelmateai/features/explore/data/models/travel_stats_isar_model.dart';
import 'package:travelmateai/features/explore/domain/entities/travel_stats.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';

/// Computes and persists travel statistics from local trip data.
class TravelStatsRepository {
  TravelStatsRepository(
    this._db, {
    required NetworkInfo networkInfo,
    required TravelStatsRemoteDataSource remote,
  })  : _network = networkInfo,
        _remote = remote;

  final DatabaseService _db;
  final NetworkInfo _network;
  final TravelStatsRemoteDataSource _remote;

  Future<TravelStats> computeForUser(String userId, List<Trip> trips) async {
    final countries = trips.map((t) => t.destination.split(',').last.trim()).toSet();
    final days = trips.fold<int>(
      0,
      (sum, t) => sum + t.endDate.difference(t.startDate).inDays + 1,
    );
    final budget = trips.fold<double>(0, (sum, t) => sum + t.budget);

    final now = DateTime.now();
    final stats = TravelStats(
      id: userId,
      userId: userId,
      totalTrips: trips.length,
      totalCountries: countries.length,
      totalDaysTraveled: days,
      totalExpenses: budget,
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    final isar = _db.isar;
    if (isar != null) {
      await isar.writeTxn(
        () => isar.travelStatsIsarModels.put(TravelStatsIsarModel.fromEntity(stats)),
      );
    }
    await _trySync(stats);
    return stats;
  }

  Future<TravelStats?> getForUser(String userId) async {
    final isar = _db.isar;
    if (isar == null) return null;
    final m =
        await isar.travelStatsIsarModels.filter().statsIdEqualTo(userId).findFirst();
    return m?.toEntity();
  }

  Future<void> sync(String userId) async {
    if (!await _network.isConnected) return;
    final isar = _db.isar;
    if (isar == null) return;

    final pending = await isar.travelStatsIsarModels
        .filter()
        .userIdEqualTo(userId)
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
    for (final m in pending) {
      final stats = m.toEntity();
      try {
        await _remote.upsert(stats);
        await _markSynced(stats.id);
      } catch (e, st) {
        AppLogger.warning('Travel stats sync failed for ${stats.id}', e, st);
      }
    }

    final remote = await _remote.fetch(userId);
    if (remote != null) {
      await isar.writeTxn(
        () => isar.travelStatsIsarModels.put(TravelStatsIsarModel.fromEntity(remote)),
      );
    }
  }

  Future<void> _markSynced(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m = await isar.travelStatsIsarModels.filter().statsIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.syncStatus = SyncStatus.synced;
      await isar.travelStatsIsarModels.put(m);
    });
  }

  Future<void> _trySync(TravelStats stats) async {
    if (!await _network.isConnected) return;
    try {
      await _remote.upsert(stats);
      await _markSynced(stats.id);
    } catch (e, st) {
      AppLogger.warning('Immediate travel stats sync failed', e, st);
    }
  }
}
