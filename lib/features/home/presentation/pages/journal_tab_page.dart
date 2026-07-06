import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/journal/presentation/controllers/journal_controller.dart';
import 'package:travelmateai/shared/widgets/ad_banner_widget.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

/// Journal tab — bottom navigation destination for travel memories.
class JournalTabPage extends GetView<JournalController> {
  const JournalTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'journal_photo',
            onPressed: controller.addPhotoEntry,
            child: const Icon(Icons.photo_camera),
          ),
          const SizedBox(height: AppSpacing.sm),
          FloatingActionButton.extended(
            heroTag: 'journal_note',
            onPressed: () => _addNote(context),
            icon: const Icon(Icons.edit_note),
            label: const Text('New Entry'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const AppLoadingView();
              if (controller.entries.isEmpty) {
                return AppEmptyView(
                  title: 'Your travel story',
                  subtitle: 'Add notes, photos, and memories from your trips.',
                  icon: Icons.menu_book_outlined,
                  actionLabel: 'Write Entry',
                  onAction: () => _addNote(context),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadEntries,
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: controller.entries.length,
                  itemBuilder: (context, i) {
                    final e = controller.entries[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.book_outlined)),
                        title: Text(e.title),
                        subtitle: Text(
                          '${e.placeName ?? ''}\n${e.content}'.trim(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          DateFormat.MMMd().format(e.entryDate ?? e.createdAt),
                        ),
                        onLongPress: () => controller.deleteEntry(e.id),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }

  void _addNote(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();
    final place = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Journal Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: place,
              decoration: const InputDecoration(labelText: 'Place'),
            ),
            TextField(
              controller: content,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await controller.addEntry(
                title: title.text,
                content: content.text,
                place: place.text.isEmpty ? null : place.text,
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
