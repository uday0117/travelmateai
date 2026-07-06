import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/firebase_service.dart';

/// Deletes all user-owned cloud data when an account is removed.
class UserDataCleanupService {
  UserDataCleanupService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  static const _userCollections = [
    FirestoreConstants.tripsCollection,
    FirestoreConstants.expensesCollection,
    FirestoreConstants.favoritesCollection,
    FirestoreConstants.packingListsCollection,
    FirestoreConstants.documentsCollection,
    FirestoreConstants.journalEntriesCollection,
    FirestoreConstants.visitedPlacesCollection,
    FirestoreConstants.travelStatsCollection,
    FirestoreConstants.notificationsCollection,
  ];

  Future<void> deleteAllUserData(String userId) async {
    if (!FirebaseService.isInitialized) return;

    for (final collection in _userCollections) {
      await _deleteCollectionForUser(collection, userId);
    }

    await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .delete()
        .catchError((Object e, StackTrace st) {
      AppLogger.warning('User profile delete failed', e, st);
    });

    await _firestore
        .collection(FirestoreConstants.settingsCollection)
        .doc(userId)
        .delete()
        .catchError((Object e, StackTrace st) {
      AppLogger.warning('User settings delete failed', e, st);
    });

    try {
      final storageRef = _storage.ref().child('users/$userId');
      final list = await storageRef.listAll();
      await Future.wait([
        ...list.items.map((item) => item.delete()),
        ...list.prefixes.map(_deleteStorageFolder),
      ]);
    } catch (e, st) {
      AppLogger.warning('Storage cleanup failed for $userId', e, st);
    }
  }

  Future<void> _deleteCollectionForUser(String collection, String userId) async {
    try {
      final snapshot = await _firestore
          .collection(collection)
          .where(FirestoreConstants.userIdField, isEqualTo: userId)
          .get();
      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e, st) {
      AppLogger.warning('Failed to delete $collection for $userId', e, st);
    }
  }

  Future<void> _deleteStorageFolder(Reference folder) async {
    final nested = await folder.listAll();
    await Future.wait([
      ...nested.items.map((item) => item.delete()),
      ...nested.prefixes.map(_deleteStorageFolder),
    ]);
  }
}
