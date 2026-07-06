import 'package:isar/isar.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/core/services/encryption_service.dart';
import 'package:travelmateai/features/documents/data/datasources/document_remote_datasource.dart';
import 'package:travelmateai/features/documents/data/models/document_isar_model.dart';
import 'package:travelmateai/features/documents/domain/entities/travel_document.dart';

class DocumentLocalDataSource {
  DocumentLocalDataSource(this._db, this._encryption);
  final DatabaseService _db;
  final EncryptionService _encryption;

  Future<List<TravelDocument>> getAll(String userId) async {
    final isar = _db.isar;
    if (isar == null) return [];
    final models = await isar.documentIsarModels.filter().userIdEqualTo(userId).findAll();
    return models.where((m) => !m.isDeleted).map((m) => m.toEntity()).toList();
  }

  Future<TravelDocument?> getById(String id) async {
    final isar = _db.isar;
    if (isar == null) return null;
    final m = await isar.documentIsarModels.filter().documentIdEqualTo(id).findFirst();
    return m?.toEntity();
  }

  Future<List<TravelDocument>> getPendingSync() async {
    final isar = _db.isar;
    if (isar == null) return [];
    final models =
        await isar.documentIsarModels.filter().syncStatusEqualTo(SyncStatus.pending).findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<TravelDocument> save(TravelDocument doc, {String? plainNotes}) async {
    final isar = _db.isar;
    if (isar == null) return doc;
    var entity = doc;
    if (plainNotes != null) {
      entity = doc.copyWith(encryptedData: _encryption.encrypt(plainNotes));
    }
    await isar.writeTxn(() => isar.documentIsarModels.put(DocumentIsarModel.fromEntity(entity)));
    return entity;
  }

  Future<void> markSynced(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m = await isar.documentIsarModels.filter().documentIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.syncStatus = SyncStatus.synced;
      await isar.documentIsarModels.put(m);
    });
  }

  Future<void> delete(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m = await isar.documentIsarModels.filter().documentIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.isDeleted = true;
      m.syncStatus = SyncStatus.pending;
      m.updatedAt = DateTime.now();
      await isar.documentIsarModels.put(m);
    });
  }

  String? decryptNotes(TravelDocument doc) {
    if (doc.encryptedData == null) return doc.notes;
    return _encryption.decrypt(doc.encryptedData!);
  }
}

abstract class DocumentRepository {
  Future<List<TravelDocument>> getAll(String userId);
  Future<TravelDocument> save(TravelDocument doc, {String? plainNotes});
  Future<void> delete(String id);
  Future<void> sync(String userId);
  String? decryptNotes(TravelDocument doc);
}

class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl({
    required DocumentLocalDataSource local,
    required DocumentRemoteDataSource remote,
    required NetworkInfo networkInfo,
  })  : _local = local,
        _remote = remote,
        _network = networkInfo;

  final DocumentLocalDataSource _local;
  final DocumentRemoteDataSource _remote;
  final NetworkInfo _network;

  @override
  Future<List<TravelDocument>> getAll(String userId) => _local.getAll(userId);

  @override
  Future<TravelDocument> save(TravelDocument doc, {String? plainNotes}) async {
    final entity = doc.copyWith(
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
    );
    final saved = await _local.save(entity, plainNotes: plainNotes);
    await _trySync(saved);
    return saved;
  }

  @override
  Future<void> delete(String id) async {
    final existing = await _local.getById(id);
    await _local.delete(id);
    if (existing != null) {
      await _trySync(existing.copyWith(isDeleted: true, syncStatus: SyncStatus.pending));
    }
    if (await _network.isConnected) {
      await _remote.delete(id);
    }
  }

  @override
  Future<void> sync(String userId) async {
    if (!await _network.isConnected) return;

    for (final doc in await _local.getPendingSync()) {
      try {
        if (doc.isDeleted) {
          await _remote.delete(doc.id);
        } else {
          await _remote.upsert(doc);
        }
        await _local.markSynced(doc.id);
      } catch (e, st) {
        AppLogger.warning('Document sync failed for ${doc.id}', e, st);
      }
    }

    final remote = await _remote.fetch(userId);
    for (final doc in remote) {
      await _local.save(doc);
      await _local.markSynced(doc.id);
    }
  }

  @override
  String? decryptNotes(TravelDocument doc) => _local.decryptNotes(doc);

  Future<void> _trySync(TravelDocument doc) async {
    if (!await _network.isConnected) return;
    try {
      if (doc.isDeleted) {
        await _remote.delete(doc.id);
      } else {
        await _remote.upsert(doc);
      }
      await _local.markSynced(doc.id);
    } catch (e, st) {
      AppLogger.warning('Immediate document sync failed', e, st);
    }
  }
}
