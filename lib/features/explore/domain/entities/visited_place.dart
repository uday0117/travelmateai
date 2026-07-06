import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

/// A place the user has visited.
class VisitedPlace extends Equatable implements SyncEntity {
  const VisitedPlace({
    required this.id,
    required this.userId,
    required this.name,
    required this.country,
    this.tripId,
    this.visitedAt,
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
  final String? tripId;
  final DateTime? visitedAt;
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
  List<Object?> get props => [id, userId, name, country];

  VisitedPlace copyWith({
    String? name,
    String? country,
    String? tripId,
    DateTime? visitedAt,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return VisitedPlace(
      id: id,
      userId: userId,
      name: name ?? this.name,
      country: country ?? this.country,
      tripId: tripId ?? this.tripId,
      visitedAt: visitedAt ?? this.visitedAt,
      latitude: latitude,
      longitude: longitude,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
