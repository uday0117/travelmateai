import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/expenses/domain/entities/expense.dart';

class ExpenseRemoteDataSource {
  ExpenseRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestoreConstants.expensesCollection);

  Future<void> upsert(Expense e) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(e.id).set({
      FirestoreConstants.userIdField: e.userId,
      FirestoreConstants.tripIdField: e.tripId,
      'title': e.title,
      'amount': e.amount,
      'currency': e.currency,
      'category': e.category.name,
      'date': Timestamp.fromDate(e.date),
      'notes': e.notes,
      FirestoreConstants.syncStatusField: e.syncStatus.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(e.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(e.updatedAt),
      FirestoreConstants.isDeletedField: e.isDeleted,
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(id).delete();
  }

  Future<List<Expense>> fetch(String userId) async {
    if (!FirebaseService.isInitialized) return [];
    final snap = await _col
        .where(FirestoreConstants.userIdField, isEqualTo: userId)
        .where(FirestoreConstants.isDeletedField, isEqualTo: false)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      return Expense(
        id: d.id,
        userId: data[FirestoreConstants.userIdField] as String,
        tripId: data[FirestoreConstants.tripIdField] as String,
        title: data['title'] as String? ?? '',
        amount: (data['amount'] as num?)?.toDouble() ?? 0,
        currency: data['currency'] as String? ?? 'USD',
        category: ExpenseCategory.values.byName(data['category'] as String? ?? 'miscellaneous'),
        date: (data['date'] as Timestamp).toDate(),
        notes: data['notes'] as String?,
        syncStatus: SyncStatus.synced,
        createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
        updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
      );
    }).toList();
  }
}
