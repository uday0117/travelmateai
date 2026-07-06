import 'package:dartz/dartz.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/errors/failures.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/trips/data/datasources/trip_local_datasource.dart';
import 'package:travelmateai/features/trips/data/datasources/trip_remote_datasource.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/features/trips/domain/repositories/trip_repository.dart';
import 'package:uuid/uuid.dart';

/// Offline-first trip repository implementation.
class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl({
    required TripLocalDataSource localDataSource,
    required TripRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
    Uuid? uuid,
  })  : _local = localDataSource,
        _remote = remoteDataSource,
        _networkInfo = networkInfo,
        _uuid = uuid ?? const Uuid();

  final TripLocalDataSource _local;
  final TripRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  final Uuid _uuid;

  @override
  Future<Either<Failure, Trip>> createTrip(Trip trip) async {
    return _execute(() async {
      final now = DateTime.now();
      final entity = trip.copyWith(
        id: trip.id.isEmpty ? _uuid.v4() : trip.id,
        syncStatus: SyncStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await _local.save(entity);
      await _trySync(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, Trip>> updateTrip(Trip trip) async {
    return _execute(() async {
      final entity = trip.copyWith(
        syncStatus: SyncStatus.pending,
        updatedAt: DateTime.now(),
      );
      await _local.save(entity);
      await _trySync(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, void>> archiveTrip(String id) async {
    return _execute(() async {
      final trip = await _local.getById(id);
      if (trip == null) throw Exception('Trip not found');

      final archived = trip.copyWith(
        isArchived: true,
        status: TripStatus.archived,
        syncStatus: SyncStatus.pending,
        updatedAt: DateTime.now(),
      );
      await _local.save(archived);
      await _trySync(archived);
    });
  }

  @override
  Future<Either<Failure, Trip>> duplicateTrip(String id) async {
    return _execute(() async {
      final trip = await _local.getById(id);
      if (trip == null) throw Exception('Trip not found');

      final now = DateTime.now();
      final duplicate = trip.copyWith(
        id: _uuid.v4(),
        title: '${trip.title} (Copy)',
        isFavorite: false,
        isArchived: false,
        status: TripStatus.upcoming,
        syncStatus: SyncStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await _local.save(duplicate);
      await _trySync(duplicate);
      return duplicate;
    });
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String id) async {
    return _execute(() async {
      final trip = await _local.getById(id);
      if (trip == null) throw Exception('Trip not found');

      final updated = trip.copyWith(
        isFavorite: !trip.isFavorite,
        syncStatus: SyncStatus.pending,
        updatedAt: DateTime.now(),
      );
      await _local.save(updated);
      await _trySync(updated);
    });
  }

  @override
  Future<Trip?> getById(String id) => _local.getById(id);

  @override
  Future<List<Trip>> getAll({String? userId}) async {
    if (userId == null) return [];
    return _local.getAll(userId: userId);
  }

  @override
  Future<List<Trip>> getFiltered({
    required String userId,
    TripFilter? filter,
  }) async {
    var trips = await _local.getAll(userId: userId);
    final f = filter ?? const TripFilter();

    if (!f.includeArchived && !f.archivedOnly) {
      trips = trips.where((t) => !t.isArchived).toList();
    }
    if (f.archivedOnly) {
      trips = trips.where((t) => t.isArchived).toList();
    }
    if (f.favoritesOnly) {
      trips = trips.where((t) => t.isFavorite).toList();
    }
    if (f.status != null) {
      trips = trips.where((t) => t.status == f.status).toList();
    }
    if (f.searchQuery != null && f.searchQuery!.isNotEmpty) {
      final query = f.searchQuery!.toLowerCase();
      trips = trips.where((t) {
        return t.title.toLowerCase().contains(query) ||
            t.destination.toLowerCase().contains(query);
      }).toList();
    }

    return trips;
  }

  @override
  Future<List<Trip>> getUpcoming({required String userId, int limit = 5}) async {
    final trips = await getFiltered(userId: userId);
    final upcoming = trips.where((t) => t.isUpcoming).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    return upcoming.take(limit).toList();
  }

  @override
  Future<List<Trip>> getActive({required String userId, int limit = 5}) async {
    final trips = await getFiltered(userId: userId);
    final active = trips.where((t) => t.isOngoing).toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
    return active.take(limit).toList();
  }

  @override
  Future<List<Trip>> getRecent({required String userId, int limit = 5}) async {
    final trips = await getFiltered(userId: userId, filter: const TripFilter(includeArchived: true));
    final sorted = trips.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.take(limit).toList();
  }

  @override
  Future<Trip> save(Trip entity) async {
    final result = await updateTrip(entity);
    return result.getOrElse(() => entity);
  }

  @override
  Future<void> delete(String id) async {
    final trip = await _local.getById(id);
    if (trip == null) return;

    await _local.delete(id);
    await _trySync(trip.copyWith(isDeleted: true));

    if (await _networkInfo.isConnected) {
      await _remote.deleteTrip(id);
    }
  }

  @override
  Future<void> sync() async {
    if (!await _networkInfo.isConnected) return;

    final pending = await _local.getPendingSync();
    for (final trip in pending) {
      try {
        if (trip.isDeleted) {
          await _remote.deleteTrip(trip.id);
        } else {
          await _remote.upsertTrip(trip);
        }
        await _local.markSynced(trip.id);
      } catch (e, st) {
        AppLogger.warning('Trip sync failed for ${trip.id}', e, st);
      }
    }

    final userIds = pending.map((t) => t.userId).toSet();
    for (final userId in userIds) {
      final remoteTrips = await _remote.fetchTrips(userId);
      for (final trip in remoteTrips) {
        await _local.save(trip.copyWith(syncStatus: SyncStatus.synced));
      }
    }
  }

  @override
  Stream<List<Trip>> watchAll({String? userId}) {
    if (userId == null) return Stream.value([]);
    return _local.watchAll(userId: userId);
  }

  Future<void> _trySync(Trip trip) async {
    if (!await _networkInfo.isConnected) return;
    try {
      if (trip.isDeleted) {
        await _remote.deleteTrip(trip.id);
      } else {
        await _remote.upsertTrip(trip);
      }
      await _local.markSynced(trip.id);
    } catch (e, st) {
      AppLogger.warning('Immediate trip sync failed', e, st);
    }
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } catch (e) {
      return Left(ErrorMapper.mapException(e));
    }
  }
}
