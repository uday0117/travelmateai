import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';

enum ExpenseCategory {
  flights,
  hotels,
  food,
  taxi,
  fuel,
  shopping,
  activities,
  miscellaneous,
}

class Expense extends Equatable implements SyncEntity {
  const Expense({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.date,
    this.notes,
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
  final double amount;
  final String currency;
  final ExpenseCategory category;
  final DateTime date;
  final String? notes;
  @override
  final SyncStatus syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  Expense copyWith({
    String? id,
    String? userId,
    String? tripId,
    String? title,
    double? amount,
    String? currency,
    ExpenseCategory? category,
    DateTime? date,
    String? notes,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props =>
      [id, userId, tripId, title, amount, currency, category, date, notes, syncStatus, createdAt, updatedAt, isDeleted];
}

extension ExpenseCategoryX on ExpenseCategory {
  String get label => switch (this) {
        ExpenseCategory.flights => 'Flights',
        ExpenseCategory.hotels => 'Hotels',
        ExpenseCategory.food => 'Food',
        ExpenseCategory.taxi => 'Taxi',
        ExpenseCategory.fuel => 'Fuel',
        ExpenseCategory.shopping => 'Shopping',
        ExpenseCategory.activities => 'Activities',
        ExpenseCategory.miscellaneous => 'Miscellaneous',
      };

  String get iconName => name;
}
