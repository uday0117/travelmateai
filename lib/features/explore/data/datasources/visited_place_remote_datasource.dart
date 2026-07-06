import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/explore/domain/entities/visited_place.dart';

class VisitedPlaceRemoteDataSource {
  VisitedPlaceRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestoreConstants.visitedPlacesCollection);

  Future<void> upsert(VisitedPlace place) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(place.id).set({
      FirestoreConstants.userIdField: place.userId,
      'name': place.name,
      'country': place.country,
      FirestoreConstants.tripIdField: place.tripId,
      'visitedAt': place.visitedAt != null ? Timestamp.fromDate(place.visitedAt!) : null,
      'latitude': place.latitude,
      'longitude': place.longitude,
      FirestoreConstants.syncStatusField: place.syncStatus.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(place.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(place.updatedAt),
      FirestoreConstants.isDeletedField: place.isDeleted,
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(id).delete();
  }

  Future<List<VisitedPlace>> fetch(String userId) async {
    if (!FirebaseService.isInitialized) return [];
    final snap = await _col
        .where(FirestoreConstants.userIdField, isEqualTo: userId)
        .where(FirestoreConstants.isDeletedField, isEqualTo: false)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      return VisitedPlace(
        id: d.id,
        userId: data[FirestoreConstants.userIdField] as String,
        name: data['name'] as String? ?? '',
        country: data['country'] as String? ?? '',
        tripId: data[FirestoreConstants.tripIdField] as String?,
        visitedAt: (data['visitedAt'] as Timestamp?)?.toDate(),
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        syncStatus: SyncStatus.synced,
        createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
        updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
      );
    }).toList();
  }
}
