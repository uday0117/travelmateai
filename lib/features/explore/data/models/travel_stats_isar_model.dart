import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/explore/domain/entities/travel_stats.dart';

part 'travel_stats_isar_model.g.dart';

@collection
class TravelStatsIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String statsId;

  late String userId;
  int totalTrips = 0;
  int totalCountries = 0;
  double totalDistanceKm = 0;
  int totalDaysTraveled = 0;
  double totalExpenses = 0;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  TravelStats toEntity() => TravelStats(
        id: statsId,
        userId: userId,
        totalTrips: totalTrips,
        totalCountries: totalCountries,
        totalDistanceKm: totalDistanceKm,
        totalDaysTraveled: totalDaysTraveled,
        totalExpenses: totalExpenses,
        syncStatus: syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isDeleted: isDeleted,
      );

  static TravelStatsIsarModel fromEntity(TravelStats s) => TravelStatsIsarModel()
    ..statsId = s.id
    ..userId = s.userId
    ..totalTrips = s.totalTrips
    ..totalCountries = s.totalCountries
    ..totalDistanceKm = s.totalDistanceKm
    ..totalDaysTraveled = s.totalDaysTraveled
    ..totalExpenses = s.totalExpenses
    ..syncStatus = s.syncStatus
    ..createdAt = s.createdAt
    ..updatedAt = s.updatedAt
    ..isDeleted = s.isDeleted;
}
