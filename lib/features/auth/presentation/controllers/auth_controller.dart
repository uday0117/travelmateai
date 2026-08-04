import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/errors/failures.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/features/auth/domain/entities/app_user.dart';
import 'package:travelmateai/features/auth/domain/repositories/auth_repository.dart';

/// Auth state and sign-in actions.
class AuthController extends GetxController {
  AuthController(this._authRepository);

  final AuthRepository _authRepository;

  final Rxn<AppUser> user = Rxn<AppUser>();
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _authRepository.currentUser;
    _authRepository.authStateChanges.listen((appUser) {
      user.value = appUser;
    });
  }

  bool get isAuthenticated => user.value != null;

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _runAuth(
      () => _authRepository.signInWithEmail(email: email, password: password),
      loginMethod: 'email',
    );
  }

  Future<bool> signInWithGoogle() async {
    return _runAuth(_authRepository.signInWithGoogle, loginMethod: 'google');
  }

  Future<bool> signInAsGuest() async {
    return _runAuth(_authRepository.signInAnonymously, loginMethod: 'guest');
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return _runAuth(
      () => _authRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      ),
      loginMethod: 'email_signup',
    );
  }

  Future<bool> sendPasswordReset(String email) async {
    return _runAuth(() => _authRepository.sendPasswordResetEmail(email));
  }

  Future<bool> signOut() async {
    return _runAuth(_authRepository.signOut);
  }

  Future<bool> deleteAccount() async {
    return _runAuth(_authRepository.deleteAccount);
  }

  Future<bool> _runAuth<T>(
    Future<Either<Failure, T>> Function() action, {
    String? loginMethod,
  }) async {
    isLoading.value = true;
    try {
      final result = await action();
      return result.fold(
        (failure) {
          if (_isUserCancellation(failure)) return false;
          Get.context?.showAppSnackBar(
            ErrorMapper.userMessage(failure),
            isError: true,
          );
          return false;
        },
        (_) {
          // Ensure UI has the signed-in user immediately (don't wait on stream).
          user.value = _authRepository.currentUser ?? user.value;
          if (loginMethod != null && Get.isRegistered<AnalyticsService>()) {
            Get.find<AnalyticsService>().logLogin(method: loginMethod);
          }
          return true;
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _isUserCancellation(Failure failure) {
    if (failure is! AuthFailure) return false;
    final code = failure.code?.toLowerCase() ?? '';
    final message = failure.message.toLowerCase();
    return code == 'cancelled' ||
        code.contains('canceled') ||
        code.contains('cancelled') ||
        message.contains('cancelled') ||
        message.contains('canceled');
  }
}
