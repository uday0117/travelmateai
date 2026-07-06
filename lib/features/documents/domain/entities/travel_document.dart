import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

enum DocumentType {
  passport,
  visa,
  ticket,
  insurance,
  hotelBooking,
  emergencyContact,
  other,
}

class TravelDocument extends Equatable implements SyncEntity {
  const TravelDocument({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    this.tripId,
    this.filePath,
    this.encryptedData,
    this.expiryDate,
    this.notes,
    this.syncStatus = SyncStatus.synced,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  @override
  final String id;
  final String userId;
  final String? tripId;
  final String title;
  final DocumentType type;
  final String? filePath;
  final String? encryptedData;
  final DateTime? expiryDate;
  final String? notes;
  @override
  final SyncStatus syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  TravelDocument copyWith({
    String? title,
    String? encryptedData,
    DateTime? expiryDate,
    String? notes,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
    bool? isDeleted,
  }) =>
      TravelDocument(
        id: id,
        userId: userId,
        tripId: tripId,
        title: title ?? this.title,
        type: type,
        filePath: filePath,
        encryptedData: encryptedData ?? this.encryptedData,
        expiryDate: expiryDate ?? this.expiryDate,
        notes: notes ?? this.notes,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  @override
  List<Object?> get props =>
      [id, userId, tripId, title, type, filePath, encryptedData, expiryDate, notes, syncStatus, createdAt, updatedAt, isDeleted];
}

extension DocumentTypeX on DocumentType {
  String get label => switch (this) {
        DocumentType.passport => 'Passport',
        DocumentType.visa => 'Visa',
        DocumentType.ticket => 'Ticket',
        DocumentType.insurance => 'Insurance',
        DocumentType.hotelBooking => 'Hotel Booking',
        DocumentType.emergencyContact => 'Emergency Contact',
        DocumentType.other => 'Other',
      };
}
