import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/explore/domain/entities/visited_place.dart';

part 'visited_place_isar_model.g.dart';

@collection
class VisitedPlaceIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String placeId;

  late String userId;
  late String name;
  late String country;
  String? tripId;
  DateTime? visitedAt;
  double? latitude;
  double? longitude;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  VisitedPlace toEntity() => VisitedPlace(
        id: placeId,
        userId: userId,
        name: name,
        country: country,
        tripId: tripId,
        visitedAt: visitedAt,
        latitude: latitude,
        longitude: longitude,
        syncStatus: syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isDeleted: isDeleted,
      );

  static VisitedPlaceIsarModel fromEntity(VisitedPlace p) => VisitedPlaceIsarModel()
    ..placeId = p.id
    ..userId = p.userId
    ..name = p.name
    ..country = p.country
    ..tripId = p.tripId
    ..visitedAt = p.visitedAt
    ..latitude = p.latitude
    ..longitude = p.longitude
    ..syncStatus = p.syncStatus
    ..createdAt = p.createdAt
    ..updatedAt = p.updatedAt
    ..isDeleted = p.isDeleted;
}
