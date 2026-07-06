import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trip_form_controller.dart';
import 'package:travelmateai/shared/widgets/app_buttons.dart';

/// Create or edit trip form page.
class CreateTripPage extends GetView<TripFormController> {
  const CreateTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(
      text: controller.existingTrip?.title,
    );
    final destinationController = TextEditingController(
      text: controller.existingTrip?.destination,
    );
    final descriptionController = TextEditingController(
      text: controller.existingTrip?.description,
    );
    final budgetController = TextEditingController(
      text: controller.existingTrip?.budget.toString() ?? '0',
    );
    final travelersController = TextEditingController(
      text: (controller.existingTrip?.travelers ?? 1).toString(),
    );
    final flightController = TextEditingController(
      text: controller.existingTrip?.flightDetails,
    );
    final hotelController = TextEditingController(
      text: controller.existingTrip?.hotelDetails,
    );
    final notesController = TextEditingController(
      text: controller.existingTrip?.notes,
    );

    var startDate = controller.existingTrip?.startDate ?? DateTime.now().add(const Duration(days: 7));
    var endDate = controller.existingTrip?.endDate ?? DateTime.now().add(const Duration(days: 14));
    final formKey = GlobalKey<FormState>();
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing.value ? 'Edit Trip' : 'New Trip'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Trip Title',
                prefixIcon: Icon(Icons.title_outlined),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
            ).animate().fadeIn(),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Destination is required' : null,
            ).animate().fadeIn(delay: 50.ms),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Dates',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                          );
                          if (picked != null) setState(() => startDate = picked);
                        },
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(dateFormat.format(startDate)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: endDate,
                            firstDate: startDate,
                            lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                          );
                          if (picked != null) setState(() => endDate = picked);
                        },
                        icon: const Icon(Icons.event, size: 18),
                        label: Text(dateFormat.format(endDate)),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Budget & Travelers',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Budget',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: controller.selectedCurrency.value,
                      decoration: const InputDecoration(labelText: 'Currency'),
                      items: const [
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                        DropdownMenuItem(value: 'GBP', child: Text('GBP')),
                        DropdownMenuItem(value: 'INR', child: Text('INR')),
                      ],
                      onChanged: (v) =>
                          controller.selectedCurrency.value = v ?? 'USD',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: travelersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Travelers',
                prefixIcon: Icon(Icons.people_outline),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: flightController,
              decoration: const InputDecoration(
                labelText: 'Flight Details (optional)',
                prefixIcon: Icon(Icons.flight_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: hotelController,
              decoration: const InputDecoration(
                labelText: 'Hotel Details (optional)',
                prefixIcon: Icon(Icons.hotel_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Obx(
              () => AppPrimaryButton(
                label: controller.isEditing.value ? 'Save Changes' : 'Create Trip',
                isLoading: controller.isLoading.value,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final success = await controller.saveTrip(
                    title: titleController.text,
                    destination: destinationController.text,
                    startDate: startDate,
                    endDate: endDate,
                    description: descriptionController.text,
                    budget: double.tryParse(budgetController.text) ?? 0,
                    currency: controller.selectedCurrency.value,
                    travelers: int.tryParse(travelersController.text) ?? 1,
                    flightDetails: flightController.text,
                    hotelDetails: hotelController.text,
                    notes: notesController.text,
                  );
                  if (success) Get.back(result: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
