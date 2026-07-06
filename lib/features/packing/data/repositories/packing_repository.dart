import 'package:isar/isar.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/packing/data/datasources/packing_remote_datasource.dart';
import 'package:travelmateai/features/packing/data/models/packing_isar_model.dart';
import 'package:travelmateai/features/packing/domain/entities/packing_list.dart';
import 'package:uuid/uuid.dart';

class PackingRepository {
  PackingRepository(
    this._db, {
    required NetworkInfo networkInfo,
    required PackingRemoteDataSource remote,
    Uuid? uuid,
  })  : _network = networkInfo,
        _remote = remote,
        _uuid = uuid ?? const Uuid();

  final DatabaseService _db;
  final NetworkInfo _network;
  final PackingRemoteDataSource _remote;
  final Uuid _uuid;

  Future<List<PackingList>> getAll(String userId, {String? tripId}) async {
    final isar = _db.isar;
    if (isar == null) return [];
    var q = isar.packingIsarModels.filter().userIdEqualTo(userId);
    final models = tripId != null
        ? await q.tripIdEqualTo(tripId).findAll()
        : await q.findAll();
    return models.where((m) => !m.isDeleted).map((m) => m.toEntity()).toList();
  }

  Future<PackingList> save(PackingList list) async {
    final isar = _db.isar;
    if (isar == null) return list;
    final entity = list.id.isEmpty
        ? list.copyWith(
            syncStatus: SyncStatus.pending,
            updatedAt: DateTime.now(),
          )
        : list.copyWith(syncStatus: SyncStatus.pending, updatedAt: DateTime.now());
    await isar.writeTxn(() => isar.packingIsarModels.put(PackingIsarModel.fromEntity(entity)));
    await _trySync(entity);
    return entity;
  }

  Future<PackingList> createForTrip({
    required String userId,
    required String tripId,
    required String title,
    List<PackingItem>? items,
  }) async {
    final now = DateTime.now();
    final list = PackingList(
      id: _uuid.v4(),
      userId: userId,
      tripId: tripId,
      title: title,
      items: items ?? _defaultItems(),
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
    return save(list);
  }

  Future<void> sync(String userId) async {
    if (!await _network.isConnected) return;
    final isar = _db.isar;
    if (isar == null) return;

    final pending = await isar.packingIsarModels
        .filter()
        .userIdEqualTo(userId)
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
    for (final m in pending) {
      final list = m.toEntity();
      try {
        if (list.isDeleted) {
          await _remote.delete(list.id);
        } else {
          await _remote.upsert(list);
        }
        await _markSynced(list.id);
      } catch (e, st) {
        AppLogger.warning('Packing sync failed for ${list.id}', e, st);
      }
    }

    final remote = await _remote.fetch(userId);
    await isar.writeTxn(() async {
      for (final list in remote) {
        await isar.packingIsarModels.put(PackingIsarModel.fromEntity(list));
      }
    });
  }

  List<PackingItem> _defaultItems() => [
        PackingItem(id: _uuid.v4(), title: 'Passport', category: PackingCategory.documents),
        PackingItem(id: _uuid.v4(), title: 'Phone charger', category: PackingCategory.electronics),
        PackingItem(id: _uuid.v4(), title: 'Toothbrush', category: PackingCategory.toiletries),
        PackingItem(id: _uuid.v4(), title: 'T-shirts', category: PackingCategory.clothing),
        PackingItem(id: _uuid.v4(), title: 'Comfortable shoes', category: PackingCategory.clothing),
      ];

  Future<void> _markSynced(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m = await isar.packingIsarModels.filter().listIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.syncStatus = SyncStatus.synced;
      await isar.packingIsarModels.put(m);
    });
  }

  Future<void> _trySync(PackingList list) async {
    if (!await _network.isConnected) return;
    try {
      if (list.isDeleted) {
        await _remote.delete(list.id);
      } else {
        await _remote.upsert(list);
      }
      await _markSynced(list.id);
    } catch (e, st) {
      AppLogger.warning('Immediate packing sync failed', e, st);
    }
  }
}
