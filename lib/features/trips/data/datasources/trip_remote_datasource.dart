import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';

/// Firestore data source for trips.
class TripRemoteDataSource {
  TripRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool get _isReady => FirebaseService.isInitialized;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreConstants.tripsCollection);

  Future<void> upsertTrip(Trip trip) async {
    if (!_isReady) return;
    await _collection.doc(trip.id).set(_toMap(trip), SetOptions(merge: true));
  }

  Future<void> deleteTrip(String id) async {
    if (!_isReady) return;
    await _collection.doc(id).delete();
  }

  Future<List<Trip>> fetchTrips(String userId) async {
    if (!_isReady) return [];

    try {
      final snapshot = await _collection
          .where(FirestoreConstants.userIdField, isEqualTo: userId)
          .where(FirestoreConstants.isDeletedField, isEqualTo: false)
          .orderBy(FirestoreConstants.updatedAtField, descending: true)
          .get();

      return snapshot.docs.map(_fromMap).toList();
    } catch (e, st) {
      AppLogger.warning('Failed to fetch trips from Firestore', e, st);
      return [];
    }
  }

  Map<String, dynamic> _toMap(Trip trip) {
    return {
      FirestoreConstants.userIdField: trip.userId,
      'title': trip.title,
      'destination': trip.destination,
      'description': trip.description,
      'startDate': Timestamp.fromDate(trip.startDate),
      'endDate': Timestamp.fromDate(trip.endDate),
      'budget': trip.budget,
      'currency': trip.currency,
      'travelers': trip.travelers,
      'flightDetails': trip.flightDetails,
      'hotelDetails': trip.hotelDetails,
      'notes': trip.notes,
      'coverImageUrl': trip.coverImageUrl,
      'isFavorite': trip.isFavorite,
      'isArchived': trip.isArchived,
      'status': trip.status.name,
      FirestoreConstants.syncStatusField: trip.syncStatus.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(trip.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(trip.updatedAt),
      FirestoreConstants.isDeletedField: trip.isDeleted,
    };
  }

  Trip _fromMap(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Trip(
      id: doc.id,
      userId: data[FirestoreConstants.userIdField] as String,
      title: data['title'] as String? ?? '',
      destination: data['destination'] as String? ?? '',
      description: data['description'] as String?,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      budget: (data['budget'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] as String? ?? 'USD',
      travelers: data['travelers'] as int? ?? 1,
      flightDetails: data['flightDetails'] as String?,
      hotelDetails: data['hotelDetails'] as String?,
      notes: data['notes'] as String?,
      coverImageUrl: data['coverImageUrl'] as String?,
      isFavorite: data['isFavorite'] as bool? ?? false,
      isArchived: data['isArchived'] as bool? ?? false,
      status: TripStatus.values.byName(data['status'] as String? ?? 'upcoming'),
      syncStatus: SyncStatus.values.byName(
        data[FirestoreConstants.syncStatusField] as String? ?? 'synced',
      ),
      createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
      updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
      isDeleted: data[FirestoreConstants.isDeletedField] as bool? ?? false,
    );
  }
}
