import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

/// Saved destination or place from Explore.
class Favorite extends Equatable implements SyncEntity {
  const Favorite({
    required this.id,
    required this.userId,
    required this.name,
    required this.country,
    this.imageUrl,
    this.notes,
    this.latitude,
    this.longitude,
    this.syncStatus = SyncStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  @override
  final String id;
  final String userId;
  final String name;
  final String country;
  final String? imageUrl;
  final String? notes;
  final double? latitude;
  final double? longitude;
  @override
  final SyncStatus syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  @override
  List<Object?> get props => [id, userId, name, country, syncStatus];

  Favorite copyWith({
    String? name,
    String? country,
    String? imageUrl,
    String? notes,
    double? latitude,
    double? longitude,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Favorite(
      id: id,
      userId: userId,
      name: name ?? this.name,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
