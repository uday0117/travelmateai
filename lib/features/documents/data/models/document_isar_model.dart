import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/documents/domain/entities/travel_document.dart';

part 'document_isar_model.g.dart';

@collection
class DocumentIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String documentId;

  late String userId;
  String? tripId;
  late String title;

  @Enumerated(EnumType.name)
  DocumentType type = DocumentType.other;

  String? filePath;
  String? encryptedData;
  DateTime? expiryDate;
  String? notes;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  TravelDocument toEntity() => TravelDocument(
        id: documentId,
        userId: userId,
        tripId: tripId,
        title: title,
        type: type,
        filePath: filePath,
        encryptedData: encryptedData,
        expiryDate: expiryDate,
        notes: notes,
        syncStatus: syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isDeleted: isDeleted,
      );

  static DocumentIsarModel fromEntity(TravelDocument d) => DocumentIsarModel()
    ..documentId = d.id
    ..userId = d.userId
    ..tripId = d.tripId
    ..title = d.title
    ..type = d.type
    ..filePath = d.filePath
    ..encryptedData = d.encryptedData
    ..expiryDate = d.expiryDate
    ..notes = d.notes
    ..syncStatus = d.syncStatus
    ..createdAt = d.createdAt
    ..updatedAt = d.updatedAt
    ..isDeleted = d.isDeleted;
}
