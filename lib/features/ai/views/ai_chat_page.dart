import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/ai/controllers/ai_chat_controller.dart';
import 'package:travelmateai/features/ai/widgets/ai_message_bubble.dart';

/// AI travel chat — conversational assistant.
class AiChatPage extends GetView<AiChatController> {
  const AiChatPage({super.key});

  static const _suggestions = [
    'Help me build a 3-day itinerary for Tokyo',
    'What should I pack for a beach trip in July?',
    'How can I save money on a weekend city break?',
    'Give me 5 hidden gems in Europe for a spring trip',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: controller.messages.length,
                itemBuilder: (_, i) =>
                    AiMessageBubble(message: controller.messages[i]),
              ),
            ),
          ),
          if (controller.messages.length <= 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'Tip: ask for a day-by-day plan, a packing list, or budget advice for your next trip.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
          Obx(
            () => !controller.isSending.value
                ? SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      itemCount: _suggestions.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (_, i) {
                        final suggestion = _suggestions[i];
                        return ActionChip(
                          label: Text(suggestion),
                          onPressed: () => controller.sendMessage(suggestion),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.sm),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        hintText: 'Ask about your trip…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Obx(
                    () => IconButton.filled(
                      onPressed: controller.isSending.value
                          ? null
                          : controller.sendMessage,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
