import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/packing/presentation/controllers/packing_controller.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

class PackingPage extends GetView<PackingController> {
  const PackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packing List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () {
              if (controller.lists.isNotEmpty) {
                controller.generateAiSuggestions(controller.lists.first);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.createForCurrentTrip,
        icon: const Icon(Icons.add),
        label: const Text('New List'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoadingView();
        if (controller.lists.isEmpty) {
          return AppEmptyView(
            title: 'No packing lists',
            subtitle: 'Create a list or let AI suggest items.',
            icon: Icons.luggage_outlined,
            actionLabel: 'Create List',
            onAction: controller.createForCurrentTrip,
            tip: 'Tip: create a list for each trip so you can reuse it later.',
          );
        }

        final list = controller.lists.first;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            LinearProgressIndicator(value: list.progress),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('${list.checkedItems}/${list.totalItems} packed'),
            ),
            ...list.items.map(
              (item) => CheckboxListTile(
                value: item.isChecked,
                onChanged: (_) => controller.toggleItem(list, item.id),
                title: Text(item.title),
                subtitle: Text(item.category.name),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => _addItem(context, list),
              icon: const Icon(Icons.add),
              label: const Text('Add Custom Item'),
            ),
            Obx(
              () => controller.isGenerating.value
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      }),
    );
  }

  void _addItem(BuildContext context, dynamic list) {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Item name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              controller.addCustomItem(list, ctrl.text);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
