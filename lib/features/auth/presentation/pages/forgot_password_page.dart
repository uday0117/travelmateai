import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/shared/widgets/app_buttons.dart';

/// Forgot password screen.
class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final sent = false.obs;

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forgot your password?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Enter your email and we\'ll send you a reset link.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.isValidEmail) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => AppPrimaryButton(
                    label: sent.value ? 'Email Sent' : 'Send Reset Link',
                    isLoading: controller.isLoading.value,
                    onPressed: sent.value
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            final success = await controller.sendPasswordReset(
                              emailController.text.trim(),
                            );
                            if (success) {
                              sent.value = true;
                              if (context.mounted) {
                                context.showAppSnackBar(
                                  'Password reset email sent. Check your inbox.',
                                );
                              }
                            }
                          },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Back to Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
