import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

/// Trip lifecycle status.
enum TripStatus {
  upcoming,
  ongoing,
  completed,
  archived,
}

/// Domain trip entity.
class Trip extends Equatable implements SyncEntity {
  const Trip({
    required this.id,
    required this.userId,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.description,
    this.budget = 0,
    this.currency = 'USD',
    this.travelers = 1,
    this.flightDetails,
    this.hotelDetails,
    this.notes,
    this.coverImageUrl,
    this.isFavorite = false,
    this.isArchived = false,
    this.status = TripStatus.upcoming,
    this.syncStatus = SyncStatus.synced,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  @override
  final String id;
  final String userId;
  final String title;
  final String destination;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String currency;
  final int travelers;
  final String? flightDetails;
  final String? hotelDetails;
  final String? notes;
  final String? coverImageUrl;
  final bool isFavorite;
  final bool isArchived;
  final TripStatus status;
  @override
  final SyncStatus syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  int get durationDays => endDate.difference(startDate).inDays + 1;

  int get daysUntilStart {
    final today = DateTime.now();
    return startDate.difference(DateTime(today.year, today.month, today.day)).inDays;
  }

  bool get isUpcoming => !isArchived && startDate.isAfter(DateTime.now());
  bool get isOngoing {
    final now = DateTime.now();
    return !isArchived &&
        !startDate.isAfter(now) &&
        !endDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  Trip copyWith({
    String? id,
    String? userId,
    String? title,
    String? destination,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    String? currency,
    int? travelers,
    String? flightDetails,
    String? hotelDetails,
    String? notes,
    String? coverImageUrl,
    bool? isFavorite,
    bool? isArchived,
    TripStatus? status,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Trip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      travelers: travelers ?? this.travelers,
      flightDetails: flightDetails ?? this.flightDetails,
      hotelDetails: hotelDetails ?? this.hotelDetails,
      notes: notes ?? this.notes,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        destination,
        description,
        startDate,
        endDate,
        budget,
        currency,
        travelers,
        flightDetails,
        hotelDetails,
        notes,
        coverImageUrl,
        isFavorite,
        isArchived,
        status,
        syncStatus,
        createdAt,
        updatedAt,
        isDeleted,
      ];
}
