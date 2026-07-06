import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/journal/domain/entities/journal_entry.dart';

class JournalRemoteDataSource {
  JournalRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestoreConstants.journalEntriesCollection);

  Future<void> upsert(JournalEntry entry) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(entry.id).set({
      FirestoreConstants.userIdField: entry.userId,
      FirestoreConstants.tripIdField: entry.tripId,
      'title': entry.title,
      'content': entry.content,
      'placeName': entry.placeName,
      'photoPaths': entry.photoPaths,
      'entryDate': entry.entryDate != null ? Timestamp.fromDate(entry.entryDate!) : null,
      FirestoreConstants.syncStatusField: entry.syncStatus.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(entry.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(entry.updatedAt),
      FirestoreConstants.isDeletedField: entry.isDeleted,
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(id).delete();
  }

  Future<List<JournalEntry>> fetch(String userId) async {
    if (!FirebaseService.isInitialized) return [];
    final snap = await _col
        .where(FirestoreConstants.userIdField, isEqualTo: userId)
        .where(FirestoreConstants.isDeletedField, isEqualTo: false)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      return JournalEntry(
        id: d.id,
        userId: data[FirestoreConstants.userIdField] as String,
        tripId: data[FirestoreConstants.tripIdField] as String,
        title: data['title'] as String? ?? '',
        content: data['content'] as String? ?? '',
        placeName: data['placeName'] as String?,
        photoPaths: (data['photoPaths'] as List<dynamic>?)?.cast<String>() ?? const [],
        entryDate: (data['entryDate'] as Timestamp?)?.toDate(),
        syncStatus: SyncStatus.synced,
        createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
        updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
      );
    }).toList();
  }
}
