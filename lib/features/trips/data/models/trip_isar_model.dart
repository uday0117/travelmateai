import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';

part 'trip_isar_model.g.dart';

@collection
class TripIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String tripId;

  late String userId;
  late String title;
  late String destination;
  String? description;
  late DateTime startDate;
  late DateTime endDate;
  double budget = 0;
  String currency = 'USD';
  int travelers = 1;
  String? flightDetails;
  String? hotelDetails;
  String? notes;
  String? coverImageUrl;
  bool isFavorite = false;
  bool isArchived = false;

  @Enumerated(EnumType.name)
  TripStatus status = TripStatus.upcoming;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  Trip toEntity() {
    return Trip(
      id: tripId,
      userId: userId,
      title: title,
      destination: destination,
      description: description,
      startDate: startDate,
      endDate: endDate,
      budget: budget,
      currency: currency,
      travelers: travelers,
      flightDetails: flightDetails,
      hotelDetails: hotelDetails,
      notes: notes,
      coverImageUrl: coverImageUrl,
      isFavorite: isFavorite,
      isArchived: isArchived,
      status: status,
      syncStatus: syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }

  static TripIsarModel fromEntity(Trip trip) {
    return TripIsarModel()
      ..tripId = trip.id
      ..userId = trip.userId
      ..title = trip.title
      ..destination = trip.destination
      ..description = trip.description
      ..startDate = trip.startDate
      ..endDate = trip.endDate
      ..budget = trip.budget
      ..currency = trip.currency
      ..travelers = trip.travelers
      ..flightDetails = trip.flightDetails
      ..hotelDetails = trip.hotelDetails
      ..notes = trip.notes
      ..coverImageUrl = trip.coverImageUrl
      ..isFavorite = trip.isFavorite
      ..isArchived = trip.isArchived
      ..status = trip.status
      ..syncStatus = trip.syncStatus
      ..createdAt = trip.createdAt
      ..updatedAt = trip.updatedAt
      ..isDeleted = trip.isDeleted;
  }
}
