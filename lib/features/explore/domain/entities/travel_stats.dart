import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

/// Aggregated travel statistics for a user.
class TravelStats extends Equatable implements SyncEntity {
  const TravelStats({
    required this.id,
    required this.userId,
    this.totalTrips = 0,
    this.totalCountries = 0,
    this.totalDistanceKm = 0,
    this.totalDaysTraveled = 0,
    this.totalExpenses = 0,
    this.syncStatus = SyncStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  @override
  final String id;
  final String userId;
  final int totalTrips;
  final int totalCountries;
  final double totalDistanceKm;
  final int totalDaysTraveled;
  final double totalExpenses;
  @override
  final SyncStatus syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  @override
  List<Object?> get props => [id, userId, totalTrips, totalCountries];

  TravelStats copyWith({
    int? totalTrips,
    int? totalCountries,
    double? totalDistanceKm,
    int? totalDaysTraveled,
    double? totalExpenses,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
  }) {
    return TravelStats(
      id: id,
      userId: userId,
      totalTrips: totalTrips ?? this.totalTrips,
      totalCountries: totalCountries ?? this.totalCountries,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      totalDaysTraveled: totalDaysTraveled ?? this.totalDaysTraveled,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted,
    );
  }
}
