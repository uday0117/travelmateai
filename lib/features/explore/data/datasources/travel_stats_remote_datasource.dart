import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmateai/core/constants/firestore_constants.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/explore/domain/entities/travel_stats.dart';

class TravelStatsRemoteDataSource {
  TravelStatsRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestoreConstants.travelStatsCollection);

  Future<void> upsert(TravelStats stats) async {
    if (!FirebaseService.isInitialized) return;
    await _col.doc(stats.id).set({
      FirestoreConstants.userIdField: stats.userId,
      'totalTrips': stats.totalTrips,
      'totalCountries': stats.totalCountries,
      'totalDistanceKm': stats.totalDistanceKm,
      'totalDaysTraveled': stats.totalDaysTraveled,
      'totalExpenses': stats.totalExpenses,
      FirestoreConstants.syncStatusField: stats.syncStatus.name,
      FirestoreConstants.createdAtField: Timestamp.fromDate(stats.createdAt),
      FirestoreConstants.updatedAtField: Timestamp.fromDate(stats.updatedAt),
      FirestoreConstants.isDeletedField: stats.isDeleted,
    }, SetOptions(merge: true));
  }

  Future<TravelStats?> fetch(String userId) async {
    if (!FirebaseService.isInitialized) return null;
    final doc = await _col.doc(userId).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return TravelStats(
      id: doc.id,
      userId: data[FirestoreConstants.userIdField] as String,
      totalTrips: data['totalTrips'] as int? ?? 0,
      totalCountries: data['totalCountries'] as int? ?? 0,
      totalDistanceKm: (data['totalDistanceKm'] as num?)?.toDouble() ?? 0,
      totalDaysTraveled: data['totalDaysTraveled'] as int? ?? 0,
      totalExpenses: (data['totalExpenses'] as num?)?.toDouble() ?? 0,
      syncStatus: SyncStatus.synced,
      createdAt: (data[FirestoreConstants.createdAtField] as Timestamp).toDate(),
      updatedAt: (data[FirestoreConstants.updatedAtField] as Timestamp).toDate(),
    );
  }
}
