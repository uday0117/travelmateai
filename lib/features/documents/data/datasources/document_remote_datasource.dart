import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/documents/domain/entities/travel_document.dart';

class DocumentRemoteDataSource {
  DocumentRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestoreConstants.documentsCollection);

  Future<void> upsert(TravelDocument doc) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(doc.id).set({
      FirestoreConstants.userIdField: doc.userId,
      FirestoreConstants.tripIdField: doc.tripId,
      'title': doc.title,
      'type': doc.type.name,
      'filePath': doc.filePath,
      'encryptedData': doc.encryptedData,
      'expiryDate': doc.expiryDate != null ? Timestamp.fromDate(doc.expiryDate!) : null,
      'notes': doc.notes,
      FirestoreConstants.syncStatusField: doc.syncStatus.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(doc.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(doc.updatedAt),
      FirestoreConstants.isDeletedField: doc.isDeleted,
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(id).delete();
  }

  Future<List<TravelDocument>> fetch(String userId) async {
    if (!FirebaseService.isInitialized) return [];
    final snap = await _col
        .where(FirestoreConstants.userIdField, isEqualTo: userId)
        .where(FirestoreConstants.isDeletedField, isEqualTo: false)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      return TravelDocument(
        id: d.id,
        userId: data[FirestoreConstants.userIdField] as String,
        tripId: data[FirestoreConstants.tripIdField] as String?,
        title: data['title'] as String? ?? '',
        type: DocumentType.values.byName(data['type'] as String? ?? 'other'),
        filePath: data['filePath'] as String?,
        encryptedData: data['encryptedData'] as String?,
        expiryDate: (data['expiryDate'] as Timestamp?)?.toDate(),
        notes: data['notes'] as String?,
        syncStatus: SyncStatus.synced,
        createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
        updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
      );
    }).toList();
  }
}
