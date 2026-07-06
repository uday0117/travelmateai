import 'package:isar/isar.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/expenses/data/models/expense_isar_model.dart';
import 'package:travelmateai/features/expenses/domain/entities/expense.dart';

class ExpenseLocalDataSource {
  ExpenseLocalDataSource(this._db);
  final DatabaseService _db;
  Isar? get _isar => _db.isar;

  Future<List<Expense>> getAll({required String userId, String? tripId}) async {
    final isar = _isar;
    if (isar == null) return [];
    var q = isar.expenseIsarModels.filter().userIdEqualTo(userId);
    final models = tripId != null
        ? await q.tripIdEqualTo(tripId).sortByDateDesc().findAll()
        : await q.sortByDateDesc().findAll();
    return models.where((m) => !m.isDeleted).map((m) => m.toEntity()).toList();
  }

  Future<Expense?> getById(String id) async {
    final isar = _isar;
    if (isar == null) return null;
    final m = await isar.expenseIsarModels.filter().expenseIdEqualTo(id).findFirst();
    return m?.toEntity();
  }

  Future<Expense> save(Expense e) async {
    final isar = _isar;
    if (isar == null) return e;
    await isar.writeTxn(() => isar.expenseIsarModels.put(ExpenseIsarModel.fromEntity(e)));
    return e;
  }

  Future<void> delete(String id) async {
    final isar = _isar;
    if (isar == null) return;
    final m = await isar.expenseIsarModels.filter().expenseIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.isDeleted = true;
      m.syncStatus = SyncStatus.pending;
      m.updatedAt = DateTime.now();
      await isar.expenseIsarModels.put(m);
    });
  }

  Future<List<Expense>> getPendingSync() async {
    final isar = _isar;
    if (isar == null) return [];
    final models = await isar.expenseIsarModels.filter().syncStatusEqualTo(SyncStatus.pending).findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<void> markSynced(String id) async {
    final isar = _isar;
    if (isar == null) return;
    final m = await isar.expenseIsarModels.filter().expenseIdEqualTo(id).findFirst();
    if (m == null) return;
    await isar.writeTxn(() async {
      m.syncStatus = SyncStatus.synced;
      await isar.expenseIsarModels.put(m);
    });
  }

  Stream<List<Expense>> watchAll({required String userId, String? tripId}) async* {
    yield await getAll(userId: userId, tripId: tripId);
    final isar = _isar;
    if (isar == null) return;
    await for (final _ in isar.expenseIsarModels.watchLazy(fireImmediately: false)) {
      yield await getAll(userId: userId, tripId: tripId);
    }
  }
}
