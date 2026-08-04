import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/expenses/domain/entities/expense.dart';
import 'package:travelmateai/features/expenses/presentation/controllers/expenses_controller.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

class ExpensesPage extends GetView<ExpensesController> {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          Obx(
            () => IconButton(
              icon: controller.isAnalyzingBudget.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome_outlined),
              tooltip: 'AI Budget Advisor',
              onPressed: controller.isAnalyzingBudget.value
                  ? null
                  : controller.analyzeBudgetWithAi,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_all_outlined),
            tooltip: 'Copy expense summary',
            onPressed: controller.exportSummary,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoadingView();
        if (controller.expenses.isEmpty) {
          return AppEmptyView(
            title: 'No expenses yet',
            subtitle: 'Track flights, hotels, food and more.',
            icon: Icons.receipt_long_outlined,
            actionLabel: 'Add Expense',
            onAction: () => _showAddDialog(context),
            tip:
                'Tip: add one expense after each purchase to keep your budget realistic.',
          );
        }

        final categories = controller.byCategory;
        final colors = [
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.red,
          Colors.teal,
          Colors.amber,
          Colors.grey,
        ];

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      'Total Spent',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '\$${controller.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            if (categories.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: categories.entries.map((e) {
                      final i = e.key.index;
                      return PieChartSectionData(
                        value: e.value,
                        title:
                            '${(e.value / controller.total * 100).toStringAsFixed(0)}%',
                        color: colors[i % colors.length],
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ...controller.expenses.map(
              (e) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(_iconFor(e.category), size: 20),
                  ),
                  title: Text(e.title),
                  subtitle: Text(
                    '${e.category.label} · ${DateFormat.MMMd().format(e.date)}',
                  ),
                  trailing: Text(
                    '${e.currency} ${e.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onLongPress: () => controller.deleteExpense(e.id),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        );
      }),
    );
  }

  IconData _iconFor(ExpenseCategory c) => switch (c) {
    ExpenseCategory.flights => Icons.flight,
    ExpenseCategory.hotels => Icons.hotel,
    ExpenseCategory.food => Icons.restaurant,
    ExpenseCategory.taxi => Icons.local_taxi,
    ExpenseCategory.fuel => Icons.local_gas_station,
    ExpenseCategory.shopping => Icons.shopping_bag,
    ExpenseCategory.activities => Icons.local_activity,
    ExpenseCategory.miscellaneous => Icons.more_horiz,
  };

  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    var category = ExpenseCategory.miscellaneous;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: category,
              items: ExpenseCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (v) => category = v ?? category,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await controller.addExpense(
                title: titleCtrl.text,
                amount: double.tryParse(amountCtrl.text) ?? 0,
                category: category,
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
