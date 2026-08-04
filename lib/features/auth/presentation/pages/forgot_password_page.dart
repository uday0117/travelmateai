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
    return const _ForgotPasswordPageBody();
  }
}

class _ForgotPasswordPageBody extends StatefulWidget {
  const _ForgotPasswordPageBody();

  @override
  State<_ForgotPasswordPageBody> createState() =>
      _ForgotPasswordPageBodyState();
}

class _ForgotPasswordPageBodyState extends State<_ForgotPasswordPageBody> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  final _sent = false.obs;

  AuthController get controller => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.08),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reset password',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ).animate().fadeIn(),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Enter your email and we\'ll send you a reset link.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Email is required';
                              }
                              if (!v.isValidEmail) return 'Enter a valid email';
                              return null;
                            },
                            onFieldSubmitted: (_) => _sendReset(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Obx(
                            () => AppPrimaryButton(
                              label: _sent.value
                                  ? 'Email Sent'
                                  : 'Send Reset Link',
                              isLoading: controller.isLoading.value,
                              onPressed:
                                  _sent.value || controller.isLoading.value
                                  ? null
                                  : _sendReset,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await controller.sendPasswordReset(
      _emailController.text.trim(),
    );
    if (success) {
      _sent.value = true;
      if (mounted) {
        context.showAppSnackBar('Password reset email sent. Check your inbox.');
      }
    }
  }
}
