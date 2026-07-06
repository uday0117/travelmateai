import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/packing/domain/entities/packing_list.dart';

class PackingRemoteDataSource {
  PackingRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestoreConstants.packingListsCollection);

  Future<void> upsert(PackingList list) async {
    if (!FirebaseService.isInitialized) return;
    final items = list.items
        .map((i) => {
              'id': i.id,
              'title': i.title,
              'category': i.category.name,
              'isChecked': i.isChecked,
              'isCustom': i.isCustom,
            })
        .toList();
    await _col.doc(list.id).set({
      FirestoreConstants.userIdField: list.userId,
      FirestoreConstants.tripIdField: list.tripId,
      'title': list.title,
      'items': items,
      FirestoreConstants.syncStatusField: list.syncStatus.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(list.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(list.updatedAt),
      FirestoreConstants.isDeletedField: list.isDeleted,
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(id).delete();
  }

  Future<List<PackingList>> fetch(String userId) async {
    if (!FirebaseService.isInitialized) return [];
    final snap = await _col
        .where(FirestoreConstants.userIdField, isEqualTo: userId)
        .where(FirestoreConstants.isDeletedField, isEqualTo: false)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      final rawItems = data['items'] as List<dynamic>? ?? const [];
      final items = rawItems.map((e) {
        final map = e is Map<String, dynamic>
            ? e
            : Map<String, dynamic>.from(e as Map);
        return PackingItem(
          id: map['id'] as String,
          title: map['title'] as String,
          category: PackingCategory.values.byName(map['category'] as String),
          isChecked: map['isChecked'] as bool? ?? false,
          isCustom: map['isCustom'] as bool? ?? false,
        );
      }).toList();
      return PackingList(
        id: d.id,
        userId: data[FirestoreConstants.userIdField] as String,
        tripId: data[FirestoreConstants.tripIdField] as String,
        title: data['title'] as String? ?? '',
        items: items,
        syncStatus: SyncStatus.synced,
        createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
        updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
      );
    }).toList();
  }

  static String itemsToJson(List<PackingItem> items) => jsonEncode(
        items
            .map((i) => {
                  'id': i.id,
                  'title': i.title,
                  'category': i.category.name,
                  'isChecked': i.isChecked,
                  'isCustom': i.isCustom,
                })
            .toList(),
      );
}
