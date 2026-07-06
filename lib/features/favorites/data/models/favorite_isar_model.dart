import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/favorites/domain/entities/favorite.dart';

part 'favorite_isar_model.g.dart';

@collection
class FavoriteIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String favoriteId;

  late String userId;
  late String name;
  late String country;
  String? imageUrl;
  String? notes;
  double? latitude;
  double? longitude;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  Favorite toEntity() => Favorite(
        id: favoriteId,
        userId: userId,
        name: name,
        country: country,
        imageUrl: imageUrl,
        notes: notes,
        latitude: latitude,
        longitude: longitude,
        syncStatus: syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isDeleted: isDeleted,
      );

  static FavoriteIsarModel fromEntity(Favorite f) => FavoriteIsarModel()
    ..favoriteId = f.id
    ..userId = f.userId
    ..name = f.name
    ..country = f.country
    ..imageUrl = f.imageUrl
    ..notes = f.notes
    ..latitude = f.latitude
    ..longitude = f.longitude
    ..syncStatus = f.syncStatus
    ..createdAt = f.createdAt
    ..updatedAt = f.updatedAt
    ..isDeleted = f.isDeleted;
}
