/// Sync status for offline-first entities.
enum SyncStatus {
  synced,
  pending,
  conflict,
  failed,
}

/// Base contract for entities stored locally and synced to Firestore.
abstract class SyncEntity {
  String get id;
  SyncStatus get syncStatus;
  DateTime get updatedAt;
  DateTime get createdAt;
  bool get isDeleted;
}

/// Base repository contract for offline-first data access.
abstract class BaseRepository<T extends SyncEntity> {
  Future<T?> getById(String id);
  Future<List<T>> getAll({String? userId});
  Future<T> save(T entity);
  Future<void> delete(String id);
  Future<void> sync();
  Stream<List<T>> watchAll({String? userId});
}
