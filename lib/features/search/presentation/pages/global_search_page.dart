import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/search/presentation/controllers/search_controller.dart'
    show AppSearchController, SearchResultType;
import 'package:travelmateai/shared/widgets/app_empty_view.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

class GlobalSearchPage extends GetView<AppSearchController> {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (v) => controller.query.value = v,
          decoration: const InputDecoration(
            hintText: 'Search trips, journal, documents…',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          Obx(
            () => controller.query.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.query.value = '',
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Obx(
              () => Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: controller.filterType.value == null,
                    onSelected: () => controller.setFilter(null),
                  ),
                  _FilterChip(
                    label: 'Trips',
                    selected: controller.filterType.value == SearchResultType.trip,
                    onSelected: () => controller.setFilter(SearchResultType.trip),
                  ),
                  _FilterChip(
                    label: 'Journal',
                    selected: controller.filterType.value == SearchResultType.journal,
                    onSelected: () => controller.setFilter(SearchResultType.journal),
                  ),
                  _FilterChip(
                    label: 'Documents',
                    selected: controller.filterType.value == SearchResultType.document,
                    onSelected: () => controller.setFilter(SearchResultType.document),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const AppLoadingView();
              }

              if (controller.query.value.trim().isEmpty) {
                return _RecentSearchesSection(controller: controller);
              }

              if (controller.results.isEmpty) {
                return const AppEmptyView(
                  title: 'No results',
                  subtitle: 'Try a different search term or filter.',
                  icon: Icons.search_off_rounded,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: controller.results.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final result = controller.results[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(_iconFor(result.type)),
                    ),
                    title: Text(result.title),
                    subtitle: Text(result.subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => controller.openResult(result),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(SearchResultType type) {
    return switch (type) {
      SearchResultType.trip => Icons.card_travel,
      SearchResultType.journal => Icons.menu_book_outlined,
      SearchResultType.document => Icons.folder_outlined,
    };
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class _RecentSearchesSection extends StatelessWidget {
  const _RecentSearchesSection({required this.controller});

  final AppSearchController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recent = controller.recentSearches;
      if (recent.isEmpty) {
        return const AppEmptyView(
          title: 'Search everything',
          subtitle: 'Find trips, journal entries, and travel documents instantly.',
          icon: Icons.travel_explore,
        );
      }

      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent searches',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              TextButton(
                onPressed: controller.clearRecentSearches,
                child: const Text('Clear all'),
              ),
            ],
          ),
          ...recent.map(
            (term) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(term),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => controller.removeRecentSearch(term),
              ),
              onTap: () => controller.applyRecentSearch(term),
            ),
          ),
        ],
      );
    });
  }
}
