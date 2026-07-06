import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/ai/ai_service.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:travelmateai/features/expenses/domain/entities/expense.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

class ExpensesController extends GetxController {
  ExpensesController(this._repo, this._aiService);

  final ExpenseRepositoryImpl _repo;
  final AiService _aiService;
  final RxList<Expense> expenses = <Expense>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isAnalyzingBudget = false.obs;
  final RxnString selectedTripId = RxnString();
  final Rx<ExpenseCategory?> filterCategory = Rx<ExpenseCategory?>(null);

  String? get _userId => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
    final trips = Get.find<TripsController>();
    if (trips.trips.isNotEmpty) selectedTripId.value ??= trips.trips.first.id;
  }

  Future<void> loadExpenses() async {
    final uid = _userId;
    if (uid == null) return;
    isLoading.value = true;
    try {
      var list = await _repo.getAll(userId: uid, tripId: selectedTripId.value);
      if (filterCategory.value != null) {
        list = list.where((e) => e.category == filterCategory.value).toList();
      }
      expenses.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  double get total => _repo.totalAmount(expenses);
  Map<ExpenseCategory, double> get byCategory => _repo.categoryTotals(expenses);

  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    String currency = 'USD',
    String? notes,
  }) async {
    final uid = _userId;
    final tripId = selectedTripId.value;
    if (uid == null || tripId == null) return;

    await _repo.create(Expense(
      id: '',
      userId: uid,
      tripId: tripId,
      title: title,
      amount: amount,
      currency: currency,
      category: category,
      date: DateTime.now(),
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    if (Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logExpenseAdded(tripId: tripId);
    }
    Get.context?.showAppSnackBar('Expense added');
    await loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _repo.delete(id);
    await loadExpenses();
  }

  Future<void> analyzeBudgetWithAi() async {
    final trips = Get.find<TripsController>();
    final tripId = selectedTripId.value;
    final trip = trips.trips.where((t) => t.id == tripId).firstOrNull;
    if (trip == null) {
      Get.context?.showAppSnackBar('Select a trip first', isError: true);
      return;
    }

    isAnalyzingBudget.value = true;
    try {
      final analysis = await _aiService.suggestBudget(
        trip: trip,
        spentSoFar: total,
        expenseCount: expenses.length,
      );
      await Get.dialog<void>(
        AlertDialog(
          title: const Text('AI Budget Advisor'),
          content: SingleChildScrollView(child: Text(analysis)),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('Close')),
          ],
        ),
      );
    } catch (e) {
      Get.context?.showAppSnackBar('Budget analysis unavailable', isError: true);
    } finally {
      isAnalyzingBudget.value = false;
    }
  }

  Future<void> exportSummary() async {
    if (expenses.isEmpty) {
      Get.context?.showAppSnackBar('No expenses to export', isError: true);
      return;
    }

    final buffer = StringBuffer('TravelMate AI — Expense Summary\n');
    buffer.writeln('Total: \$${total.toStringAsFixed(2)}\n');

    if (byCategory.isNotEmpty) {
      buffer.writeln('By category:');
      for (final entry in byCategory.entries) {
        buffer.writeln('  ${entry.key.label}: \$${entry.value.toStringAsFixed(2)}');
      }
      buffer.writeln();
    }

    buffer.writeln('Items:');
    final dateFmt = DateFormat.yMMMd();
    for (final expense in expenses) {
      buffer.writeln(
        '- ${expense.title} (${expense.category.label}, ${dateFmt.format(expense.date)}): '
        '${expense.currency} ${expense.amount.toStringAsFixed(2)}',
      );
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    Get.context?.showAppSnackBar('Expense summary copied to clipboard');
  }
}
