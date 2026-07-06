import 'package:isar/isar.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/journal/data/datasources/journal_remote_datasource.dart';
import 'package:travelmateai/features/journal/data/models/journal_isar_model.dart';
import 'package:travelmateai/features/journal/domain/entities/journal_entry.dart';
import 'package:uuid/uuid.dart';

class JournalRepository {
  JournalRepository(
    this._db, {
    required NetworkInfo networkInfo,
    required JournalRemoteDataSource remote,
    Uuid? uuid,
  })  : _network = networkInfo,
        _remote = remote,
        _uuid = uuid ?? const Uuid();

  final DatabaseService _db;
  final NetworkInfo _network;
  final JournalRemoteDataSource _remote;
  final Uuid _uuid;

  Future<List<JournalEntry>> getAll(String userId, {String? tripId}) async {
    final isar = _db.isar;
    if (isar == null) return [];
    var q = isar.journalIsarModels.filter().userIdEqualTo(userId);
    final models = tripId != null
        ? await q.tripIdEqualTo(tripId).sortByUpdatedAtDesc().findAll()
        : await q.sortByUpdatedAtDesc().findAll();
    return models.where((m) => !m.isDeleted).map((m) => m.toEntity()).toList();
  }

  Future<JournalEntry> save(JournalEntry entry) async {
    final isar = _db.isar;
    if (isar == null) return entry;
    final entity = entry.copyWith(
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
    );
    await isar.writeTxn(() => isar.journalIsarModels.put(JournalIsarModel.fromEntity(entity)));
    await _trySync(entity);
    return entity;
  }

  Future<JournalEntry> create({
    required String userId,
    required String tripId,
    required String title,
    required String content,
    String? placeName,
    List<String> photoPaths = const [],
  }) async {
    final now = DateTime.now();
    final entry = JournalEntry(
      id: _uuid.v4(),
      userId: userId,
      tripId: tripId,
      title: title,
      content: content,
      placeName: placeName,
      photoPaths: photoPaths,
      entryDate: now,
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
    return save(entry);
  }

  Future<void> delete(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m = await isar.journalIsarModels.filter().journalIdEqualTo(id).findFirst();
    if (m == null) return;
    final entity = m.toEntity();
    await isar.writeTxn(() async {
      m.isDeleted = true;
      m.syncStatus = SyncStatus.pending;
      m.updatedAt = DateTime.now();
      await isar.journalIsarModels.put(m);
    });
    await _trySync(entity.copyWith(isDeleted: true, syncStatus: SyncStatus.pending));
    if (await _network.isConnected) {
      await _remote.delete(id);
    }
  }

  Future<void> sync(String userId) async {
    if (!await _network.isConnected) return;
    final isar = _db.isar;
    if (isar == null) return;

    final pending = await isar.journalIsarModels
        .filter()
        .userIdEqualTo(userId)
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
    for (final m in pending) {
      final entry = m.toEntity();
      try {
        if (entry.isDeleted) {
          await _remote.delete(entry.id);
        } else {
          await _remote.upsert(entry);
        }
        await _markSynced(entry.id);
      } catch (e, st) {
        AppLogger.warning('Journal sync failed for ${entry.id}', e, st);
      }
    }

    final remote = await _remote.fetch(userId);
    await isar.writeTxn(() async {
      for (final entry in remote) {
        await isar.journalIsarModels.put(JournalIsarModel.fromEntity(entry));
      }
    });
  }

  Future<void> _markSynced(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m = await isar.journalIsarModels.filter().journalIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.syncStatus = SyncStatus.synced;
      await isar.journalIsarModels.put(m);
    });
  }

  Future<void> _trySync(JournalEntry entry) async {
    if (!await _network.isConnected) return;
    try {
      if (entry.isDeleted) {
        await _remote.delete(entry.id);
      } else {
        await _remote.upsert(entry);
      }
      await _markSynced(entry.id);
    } catch (e, st) {
      AppLogger.warning('Immediate journal sync failed', e, st);
    }
  }
}
