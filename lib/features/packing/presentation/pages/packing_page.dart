import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/packing/domain/entities/packing_list.dart';
import 'package:travelmateai/features/packing/presentation/controllers/packing_controller.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

class PackingPage extends GetView<PackingController> {
  const PackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packing Lists'),
        actions: [
          Obx(
            () => controller.lists.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.auto_awesome_outlined),
                    tooltip: 'AI suggestions',
                    onPressed: () => controller.generateAiSuggestions(
                      controller.lists.first,
                    ),
                  )
                : const SizedBox.shrink(),
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
            title: 'No packing lists yet',
            subtitle:
                'Create a list for your next trip and keep track of everything you need.',
            icon: Icons.luggage_outlined,
            actionLabel: 'Create List',
            onAction: controller.createForCurrentTrip,
            tip: 'Tip: use AI suggestions to auto-fill common travel items.',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadLists,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              100,
            ),
            itemCount: controller.lists.length,
            itemBuilder: (context, index) {
              final list = controller.lists[index];
              return _PackingListCard(
                list: list,
                controller: controller,
              ).animate(delay: (60 * index).ms).fadeIn().slideY(begin: 0.06);
            },
          ),
        );
      }),
    );
  }
}

// ─── Packing list card ────────────────────────────────────────────────────────

class _PackingListCard extends StatelessWidget {
  const _PackingListCard({required this.list, required this.controller});

  final PackingList list;
  final PackingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDone = list.totalItems > 0 && list.checkedItems == list.totalItems;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDone
                    ? [cs.primaryContainer, cs.secondaryContainer]
                    : [
                        cs.surfaceContainerHighest.withValues(alpha: 0.6),
                        cs.surfaceContainerHighest.withValues(alpha: 0.3),
                      ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  isDone ? Icons.check_circle_rounded : Icons.luggage_outlined,
                  color: isDone ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${list.checkedItems} / ${list.totalItems} packed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // AI button
                Obx(
                  () => controller.isGenerating.value
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.auto_awesome, size: 20),
                          tooltip: 'AI suggestions',
                          onPressed: () =>
                              controller.generateAiSuggestions(list),
                        ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  tooltip: 'Add item',
                  onPressed: () => _showAddItemDialog(context, list),
                ),
              ],
            ),
          ),

          // ── Progress bar ─────────────────────────────────────────────────
          LinearProgressIndicator(
            value: list.progress,
            minHeight: 4,
            backgroundColor: cs.outlineVariant.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              isDone ? cs.primary : cs.tertiary,
            ),
          ),

          // ── Items grouped by category ─────────────────────────────────────
          if (list.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'No items yet — add one or use AI suggestions.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          else
            _CategoryGroupedItems(list: list, controller: controller),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, PackingList list) {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Item name',
            hintText: 'e.g. Sunscreen, Rain jacket…',
          ),
          onSubmitted: (_) {
            if (ctrl.text.trim().isNotEmpty) {
              controller.addCustomItem(list, ctrl.text.trim());
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                controller.addCustomItem(list, ctrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// ─── Category-grouped item list ───────────────────────────────────────────────

class _CategoryGroupedItems extends StatelessWidget {
  const _CategoryGroupedItems({required this.list, required this.controller});

  final PackingList list;
  final PackingController controller;

  static const _categoryMeta =
      <PackingCategory, ({IconData icon, String label})>{
        PackingCategory.clothing: (
          icon: Icons.checkroom_outlined,
          label: 'Clothing',
        ),
        PackingCategory.toiletries: (
          icon: Icons.soap_outlined,
          label: 'Toiletries',
        ),
        PackingCategory.electronics: (
          icon: Icons.devices_outlined,
          label: 'Electronics',
        ),
        PackingCategory.documents: (
          icon: Icons.description_outlined,
          label: 'Documents',
        ),
        PackingCategory.health: (
          icon: Icons.health_and_safety_outlined,
          label: 'Health',
        ),
        PackingCategory.accessories: (
          icon: Icons.watch_outlined,
          label: 'Accessories',
        ),
        PackingCategory.custom: (
          icon: Icons.star_border_outlined,
          label: 'Other',
        ),
      };

  Map<PackingCategory, List<PackingItem>> _grouped() {
    final map = <PackingCategory, List<PackingItem>>{};
    for (final item in list.items) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped();
    // Render unchecked categories first, then done ones
    final orderedKeys = [
      ...grouped.keys.where((k) => grouped[k]!.any((i) => !i.isChecked)),
      ...grouped.keys.where(
        (k) =>
            grouped[k]!.every((i) => i.isChecked) &&
            !grouped[k]!.any((i) => !i.isChecked),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final category in orderedKeys) ...[
          _CategoryHeader(
            category: category,
            meta: _categoryMeta[category]!,
            items: grouped[category]!,
          ),
          for (final item in grouped[category]!)
            _PackingItemTile(
              item: item,
              onToggle: () => controller.toggleItem(list, item.id),
            ),
        ],
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.category,
    required this.meta,
    required this.items,
  });

  final PackingCategory category;
  final ({IconData icon, String label}) meta;
  final List<PackingItem> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final checked = items.where((i) => i.isChecked).length;
    final allDone = checked == items.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(
            meta.icon,
            size: 15,
            color: allDone ? cs.primary : cs.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            meta.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: allDone ? cs.primary : cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$checked/${items.length}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PackingItemTile extends StatelessWidget {
  const _PackingItemTile({required this.item, required this.onToggle});

  final PackingItem item;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isChecked ? cs.primary : Colors.transparent,
                border: Border.all(
                  color: item.isChecked ? cs.primary : cs.outline,
                  width: 1.5,
                ),
              ),
              child: item.isChecked
                  ? Icon(Icons.check_rounded, size: 14, color: cs.onPrimary)
                  : null,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: item.isChecked
                      ? TextDecoration.lineThrough
                      : null,
                  color: item.isChecked ? cs.onSurfaceVariant : cs.onSurface,
                ),
              ),
            ),
            if (item.isCustom)
              Icon(Icons.star_rounded, size: 12, color: cs.tertiary),
          ],
        ),
      ),
    );
  }
}
