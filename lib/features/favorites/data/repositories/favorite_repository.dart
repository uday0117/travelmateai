import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/favorites/data/models/favorite_isar_model.dart';
import 'package:travelmateai/features/favorites/domain/entities/favorite.dart';
import 'package:uuid/uuid.dart';

class FavoriteRepository {
  FavoriteRepository(this._db, {Uuid? uuid, FirebaseFirestore? firestore})
      : _uuid = uuid ?? const Uuid(),
        _firestore = firestore;

  final DatabaseService _db;
  final Uuid _uuid;
  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>>? get _collection {
    if (!FirebaseService.isInitialized) return null;
    return (_firestore ?? FirebaseFirestore.instance)
        .collection(FirestoreConstants.favoritesCollection);
  }

  Future<List<Favorite>> getAll(String userId) async {
    final isar = _db.isar;
    if (isar == null) return [];
    final models =
        await isar.favoriteIsarModels.filter().userIdEqualTo(userId).findAll();
    return models.where((m) => !m.isDeleted).map((m) => m.toEntity()).toList();
  }

  Future<Favorite> add({
    required String userId,
    required String name,
    required String country,
    String? imageUrl,
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    final now = DateTime.now();
    final favorite = Favorite(
      id: _uuid.v4(),
      userId: userId,
      name: name,
      country: country,
      imageUrl: imageUrl,
      notes: notes,
      latitude: latitude,
      longitude: longitude,
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
    await _saveLocal(favorite);
    await _pushRemote(favorite);
    return favorite;
  }

  Future<void> remove(String id) async {
    final isar = _db.isar;
    if (isar == null) return;
    final m =
        await isar.favoriteIsarModels.filter().favoriteIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.isDeleted = true;
      m.syncStatus = SyncStatus.pending;
      m.updatedAt = DateTime.now();
      await isar.favoriteIsarModels.put(m);
    });
    await _collection?.doc(id).set({
      FirestoreConstants.isDeletedField: true,
      FirestoreConstants.updatedAtField: FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> sync(String userId) async {
    final col = _collection;
    if (col == null) return;
    final isar = _db.isar;
    if (isar == null) return;

    final pending = await isar.favoriteIsarModels
        .filter()
        .userIdEqualTo(userId)
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
    for (final m in pending) {
      await _pushRemote(m.toEntity());
    }

    final snap = await col
        .where(FirestoreConstants.userIdField, isEqualTo: userId)
        .where(FirestoreConstants.isDeletedField, isEqualTo: false)
        .get();
    await isar.writeTxn(() async {
      for (final doc in snap.docs) {
        final data = doc.data();
        final entity = Favorite(
          id: doc.id,
          userId: data[FirestoreConstants.userIdField] as String,
          name: data['name'] as String,
          country: data['country'] as String,
          imageUrl: data['imageUrl'] as String?,
          notes: data['notes'] as String?,
          latitude: (data['latitude'] as num?)?.toDouble(),
          longitude: (data['longitude'] as num?)?.toDouble(),
          syncStatus: SyncStatus.synced,
          createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
          updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
        );
        await isar.favoriteIsarModels.put(FavoriteIsarModel.fromEntity(entity));
      }
    });
  }

  Future<void> _saveLocal(Favorite favorite) async {
    final isar = _db.isar;
    if (isar == null) return;
    await isar.writeTxn(
      () => isar.favoriteIsarModels.put(FavoriteIsarModel.fromEntity(favorite)),
    );
  }

  Future<void> _pushRemote(Favorite favorite) async {
    final col = _collection;
    if (col == null) return;
    await col.doc(favorite.id).set({
      FirestoreConstants.userIdField: favorite.userId,
      'name': favorite.name,
      'country': favorite.country,
      'imageUrl': favorite.imageUrl,
      'notes': favorite.notes,
      'latitude': favorite.latitude,
      'longitude': favorite.longitude,
      FirestoreConstants.syncStatusField: SyncStatus.synced.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(favorite.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(favorite.updatedAt),
      FirestoreConstants.isDeletedField: favorite.isDeleted,
    }, SetOptions(merge: true));

    final isar = _db.isar;
    if (isar == null) return;
    final m =
        await isar.favoriteIsarModels.filter().favoriteIdEqualTo(favorite.id).findFirst();
    if (m != null) {
      await isar.writeTxn(() async {
        m.syncStatus = SyncStatus.synced;
        await isar.favoriteIsarModels.put(m);
      });
    }
  }
}
