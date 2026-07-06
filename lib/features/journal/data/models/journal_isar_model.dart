import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/journal/domain/entities/journal_entry.dart';

part 'journal_isar_model.g.dart';

@collection
class JournalIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String journalId;

  late String userId;
  late String tripId;
  late String title;
  late String content;
  String? placeName;
  late String photoPathsJson;
  DateTime? entryDate;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  JournalEntry toEntity() {
    final paths = (jsonDecode(photoPathsJson) as List<dynamic>).cast<String>();
    return JournalEntry(
      id: journalId,
      userId: userId,
      tripId: tripId,
      title: title,
      content: content,
      placeName: placeName,
      photoPaths: paths,
      entryDate: entryDate,
      syncStatus: syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }

  static JournalIsarModel fromEntity(JournalEntry e) => JournalIsarModel()
    ..journalId = e.id
    ..userId = e.userId
    ..tripId = e.tripId
    ..title = e.title
    ..content = e.content
    ..placeName = e.placeName
    ..photoPathsJson = jsonEncode(e.photoPaths)
    ..entryDate = e.entryDate
    ..syncStatus = e.syncStatus
    ..createdAt = e.createdAt
    ..updatedAt = e.updatedAt
    ..isDeleted = e.isDeleted;
}
