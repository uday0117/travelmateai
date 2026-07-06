import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/documents/domain/entities/travel_document.dart';
import 'package:travelmateai/features/documents/presentation/controllers/documents_controller.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

class DocumentVaultPage extends StatefulWidget {
  const DocumentVaultPage({super.key});

  @override
  State<DocumentVaultPage> createState() => _DocumentVaultPageState();
}

class _DocumentVaultPageState extends State<DocumentVaultPage> {
  @override
  void initState() {
    super.initState();
    DocumentsBinding().dependencies();
    _unlock();
  }

  Future<void> _unlock() async {
    final c = Get.find<DocumentsController>();
    await c.unlockVault();
    await c.loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Vault'),
        actions: [
          IconButton(icon: const Icon(Icons.lock_outline), onPressed: _unlock),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addDocument(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Add Document'),
      ),
      body: Obx(() {
        if (!controller.isUnlocked.value) {
          return const Center(child: Text('Vault locked — tap lock icon to unlock'));
        }
        if (controller.isLoading.value) return const AppLoadingView();
        if (controller.documents.isEmpty) {
          return AppEmptyView(
            title: 'Secure document storage',
            subtitle: 'Store passport, visa, tickets and more with biometric lock.',
            icon: Icons.folder_special_outlined,
            actionLabel: 'Add Document',
            onAction: () => _addDocument(context, controller),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: controller.documents.length,
          itemBuilder: (context, i) {
            final doc = controller.documents[i];
            return Card(
              child: ListTile(
                leading: Icon(_icon(doc.type)),
                title: Text(doc.title),
                subtitle: Text(doc.type.label),
                trailing: const Icon(Icons.lock, size: 16),
                onLongPress: () => controller.deleteDocument(doc.id),
              ),
            );
          },
        );
      }),
    );
  }

  IconData _icon(DocumentType t) => switch (t) {
        DocumentType.passport => Icons.card_membership,
        DocumentType.visa => Icons.badge_outlined,
        DocumentType.ticket => Icons.confirmation_number,
        DocumentType.insurance => Icons.health_and_safety,
        DocumentType.hotelBooking => Icons.hotel,
        DocumentType.emergencyContact => Icons.contact_emergency,
        DocumentType.other => Icons.description,
      };

  void _addDocument(BuildContext context, DocumentsController c) {
    final title = TextEditingController();
    final notes = TextEditingController();
    var type = DocumentType.passport;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
            DropdownButtonFormField<DocumentType>(
              initialValue: type,
              items: DocumentType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (v) => type = v ?? type,
            ),
            TextField(controller: notes, decoration: const InputDecoration(labelText: 'Notes (encrypted)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await c.addDocument(title: title.text, type: type, notes: notes.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
