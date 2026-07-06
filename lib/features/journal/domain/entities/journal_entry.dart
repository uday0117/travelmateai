import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

class JournalEntry extends Equatable implements SyncEntity {
  const JournalEntry({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.title,
    required this.content,
    this.placeName,
    this.photoPaths = const [],
    this.entryDate,
    this.syncStatus = SyncStatus.synced,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  @override
  final String id;
  final String userId;
  final String tripId;
  final String title;
  final String content;
  final String? placeName;
  final List<String> photoPaths;
  final DateTime? entryDate;
  @override
  final SyncStatus syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  JournalEntry copyWith({
    String? title,
    String? content,
    String? placeName,
    List<String>? photoPaths,
    DateTime? entryDate,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
    bool? isDeleted,
  }) =>
      JournalEntry(
        id: id,
        userId: userId,
        tripId: tripId,
        title: title ?? this.title,
        content: content ?? this.content,
        placeName: placeName ?? this.placeName,
        photoPaths: photoPaths ?? this.photoPaths,
        entryDate: entryDate ?? this.entryDate,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  @override
  List<Object?> get props =>
      [id, userId, tripId, title, content, placeName, photoPaths, entryDate, syncStatus, createdAt, updatedAt, isDeleted];
}
