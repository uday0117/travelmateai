import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/expenses/domain/entities/expense.dart';

part 'expense_isar_model.g.dart';

@collection
class ExpenseIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String expenseId;

  late String userId;
  late String tripId;
  late String title;
  double amount = 0;
  String currency = 'USD';

  @Enumerated(EnumType.name)
  ExpenseCategory category = ExpenseCategory.miscellaneous;

  late DateTime date;
  String? notes;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  late DateTime createdAt;
  late DateTime updatedAt;
  bool isDeleted = false;

  Expense toEntity() => Expense(
        id: expenseId,
        userId: userId,
        tripId: tripId,
        title: title,
        amount: amount,
        currency: currency,
        category: category,
        date: date,
        notes: notes,
        syncStatus: syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isDeleted: isDeleted,
      );

  static ExpenseIsarModel fromEntity(Expense e) => ExpenseIsarModel()
    ..expenseId = e.id
    ..userId = e.userId
    ..tripId = e.tripId
    ..title = e.title
    ..amount = e.amount
    ..currency = e.currency
    ..category = e.category
    ..date = e.date
    ..notes = e.notes
    ..syncStatus = e.syncStatus
    ..createdAt = e.createdAt
    ..updatedAt = e.updatedAt
    ..isDeleted = e.isDeleted;
}
