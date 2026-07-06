import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/trips/data/models/trip_isar_model.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';

/// Isar local data source for trips.
class TripLocalDataSource {
  TripLocalDataSource(this._databaseService);

  final DatabaseService _databaseService;

  Isar? get _isar => _databaseService.isar;

  Future<List<Trip>> getAll({required String userId, bool includeDeleted = false}) async {
    final isar = _isar;
    if (isar == null) return [];

    final models = await isar.tripIsarModels
        .filter()
        .userIdEqualTo(userId)
        .sortByUpdatedAtDesc()
        .findAll();

    return models
        .where((m) => includeDeleted || !m.isDeleted)
        .map((m) => m.toEntity())
        .toList();
  }

  Future<Trip?> getById(String id) async {
    final isar = _isar;
    if (isar == null) return null;

    final model = await isar.tripIsarModels.filter().tripIdEqualTo(id).findFirst();
    return model?.toEntity();
  }

  Future<Trip> save(Trip trip) async {
    final isar = _isar;
    if (isar == null) return trip;

    await isar.writeTxn(() async {
      await isar.tripIsarModels.put(TripIsarModel.fromEntity(trip));
    });
    return trip;
  }

  Future<void> delete(String id) async {
    final isar = _isar;
    if (isar == null) return;

    final model = await isar.tripIsarModels.filter().tripIdEqualTo(id).findFirst();
    if (model == null) return;

    await isar.writeTxn(() async {
      model.isDeleted = true;
      model.syncStatus = SyncStatus.pending;
      model.updatedAt = DateTime.now();
      await isar.tripIsarModels.put(model);
    });
  }

  Future<List<Trip>> getPendingSync() async {
    final isar = _isar;
    if (isar == null) return [];

    final models = await isar.tripIsarModels
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  Future<void> markSynced(String id) async {
    final isar = _isar;
    if (isar == null) return;

    final model = await isar.tripIsarModels.filter().tripIdEqualTo(id).findFirst();
    if (model == null) return;

    await isar.writeTxn(() async {
      model.syncStatus = SyncStatus.synced;
      await isar.tripIsarModels.put(model);
    });
  }

  Stream<List<Trip>> watchAll({required String userId}) async* {
    final isar = _isar;
    if (isar == null) {
      yield [];
      return;
    }

    yield await getAll(userId: userId);

    await for (final _ in isar.tripIsarModels.watchLazy(fireImmediately: false)) {
      yield await getAll(userId: userId);
    }
  }
}
