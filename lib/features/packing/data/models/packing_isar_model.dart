import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/packing/domain/entities/packing_list.dart';

part 'packing_isar_model.g.dart';

@collection
class PackingIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String listId;

  late String userId;
  late String tripId;
  late String title;
  late String itemsJson;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  PackingList toEntity() {
    final decoded = jsonDecode(itemsJson) as List<dynamic>;
    final items = decoded.map((e) {
      final map = e as Map<String, dynamic>;
      return PackingItem(
        id: map['id'] as String,
        title: map['title'] as String,
        category: PackingCategory.values.byName(map['category'] as String),
        isChecked: map['isChecked'] as bool? ?? false,
        isCustom: map['isCustom'] as bool? ?? false,
      );
    }).toList();

    return PackingList(
      id: listId,
      userId: userId,
      tripId: tripId,
      title: title,
      items: items,
      syncStatus: syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }

  static PackingIsarModel fromEntity(PackingList list) {
    final itemsJson = jsonEncode(list.items.map((i) => {
          'id': i.id,
          'title': i.title,
          'category': i.category.name,
          'isChecked': i.isChecked,
          'isCustom': i.isCustom,
        }).toList());

    return PackingIsarModel()
      ..listId = list.id
      ..userId = list.userId
      ..tripId = list.tripId
      ..title = list.title
      ..itemsJson = itemsJson
      ..syncStatus = list.syncStatus
      ..createdAt = list.createdAt
      ..updatedAt = list.updatedAt
      ..isDeleted = list.isDeleted;
  }
}
