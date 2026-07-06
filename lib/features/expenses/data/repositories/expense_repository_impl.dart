import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:travelmateai/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:travelmateai/features/expenses/domain/entities/expense.dart';
import 'package:uuid/uuid.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAll({required String userId, String? tripId});
  Stream<List<Expense>> watchAll({required String userId, String? tripId});
  Future<Expense> create(Expense expense);
  Future<Expense> update(Expense expense);
  Future<void> delete(String id);
  Future<void> sync();
  Map<ExpenseCategory, double> categoryTotals(List<Expense> expenses);
  double totalAmount(List<Expense> expenses);
}

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl({
    required ExpenseLocalDataSource local,
    required ExpenseRemoteDataSource remote,
    required NetworkInfo networkInfo,
    Uuid? uuid,
  })  : _local = local,
        _remote = remote,
        _network = networkInfo,
        _uuid = uuid ?? const Uuid();

  final ExpenseLocalDataSource _local;
  final ExpenseRemoteDataSource _remote;
  final NetworkInfo _network;
  final Uuid _uuid;

  @override
  Future<List<Expense>> getAll({required String userId, String? tripId}) =>
      _local.getAll(userId: userId, tripId: tripId);

  @override
  Stream<List<Expense>> watchAll({required String userId, String? tripId}) =>
      _local.watchAll(userId: userId, tripId: tripId);

  @override
  Future<Expense> create(Expense expense) async {
    final now = DateTime.now();
    final e = expense.copyWith(
      id: expense.id.isEmpty ? _uuid.v4() : expense.id,
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
    await _local.save(e);
    await _trySync(e);
    return e;
  }

  @override
  Future<Expense> update(Expense expense) async {
    final e = expense.copyWith(syncStatus: SyncStatus.pending, updatedAt: DateTime.now());
    await _local.save(e);
    await _trySync(e);
    return e;
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
    final e = await _local.getById(id);
    if (e != null) await _trySync(e.copyWith(isDeleted: true));
    if (await _network.isConnected) await _remote.delete(id);
  }

  @override
  Future<void> sync() async {
    if (!await _network.isConnected) return;
    for (final e in await _local.getPendingSync()) {
      if (e.isDeleted) {
        await _remote.delete(e.id);
      } else {
        await _remote.upsert(e);
      }
      await _local.markSynced(e.id);
    }
  }

  @override
  Map<ExpenseCategory, double> categoryTotals(List<Expense> expenses) {
    final map = <ExpenseCategory, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  @override
  double totalAmount(List<Expense> expenses) =>
      expenses.fold(0, (sum, e) => sum + e.amount);

  Future<void> _trySync(Expense e) async {
    if (!await _network.isConnected) return;
    try {
      if (e.isDeleted) {
        await _remote.delete(e.id);
      } else {
        await _remote.upsert(e);
      }
      await _local.markSynced(e.id);
    } catch (_) {}
  }
}
