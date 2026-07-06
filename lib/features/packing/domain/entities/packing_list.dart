import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

enum PackingCategory {
  clothing,
  toiletries,
  electronics,
  documents,
  health,
  accessories,
  custom,
}

class PackingItem extends Equatable {
  const PackingItem({
    required this.id,
    required this.title,
    required this.category,
    this.isChecked = false,
    this.isCustom = false,
  });

  final String id;
  final String title;
  final PackingCategory category;
  final bool isChecked;
  final bool isCustom;

  PackingItem copyWith({bool? isChecked, String? title}) => PackingItem(
        id: id,
        title: title ?? this.title,
        category: category,
        isChecked: isChecked ?? this.isChecked,
        isCustom: isCustom,
      );

  @override
  List<Object?> get props => [id, title, category, isChecked, isCustom];
}

class PackingList extends Equatable implements SyncEntity {
  const PackingList({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.title,
    required this.items,
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
  final List<PackingItem> items;
  @override
  final SyncStatus syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  int get totalItems => items.length;
  int get checkedItems => items.where((i) => i.isChecked).length;
  double get progress => totalItems == 0 ? 0 : checkedItems / totalItems;

  PackingList copyWith({
    List<PackingItem>? items,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
    bool? isDeleted,
  }) =>
      PackingList(
        id: id,
        userId: userId,
        tripId: tripId,
        title: title,
        items: items ?? this.items,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  @override
  List<Object?> get props => [id, userId, tripId, title, items, syncStatus, createdAt, updatedAt, isDeleted];
}
