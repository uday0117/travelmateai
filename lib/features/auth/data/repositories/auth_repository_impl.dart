import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/errors/exceptions.dart';
import 'package:travelmateai/core/errors/failures.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/core/services/firestore_user_service.dart';
import 'package:travelmateai/core/services/user_data_cleanup_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/features/auth/data/models/app_user_model.dart';
import 'package:travelmateai/features/auth/domain/entities/app_user.dart';
import 'package:travelmateai/features/auth/domain/repositories/auth_repository.dart';

/// Firebase Auth repository implementation.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    UserDataCleanupService? userDataCleanup,
    FirestoreUserService? firestoreUserService,
    DatabaseService? databaseService,
    StorageService? storageService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _userDataCleanup = userDataCleanup ?? UserDataCleanupService(),
        _firestoreUserService = firestoreUserService ?? FirestoreUserService(),
        _databaseService = databaseService,
        _storageService = storageService;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserDataCleanupService _userDataCleanup;
  final FirestoreUserService _firestoreUserService;
  final DatabaseService? _databaseService;
  final StorageService? _storageService;

  bool get _isFirebaseReady => FirebaseService.isInitialized;

  @override
  Stream<AppUser?> get authStateChanges {
    if (!_isFirebaseReady) return Stream.value(null);
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  AppUser? get currentUser {
    if (!_isFirebaseReady) return null;
    return _mapUser(_firebaseAuth.currentUser);
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _execute(() async {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _requireUser(credential.user);
    });
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return _execute(() async {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null) {
        await credential.user?.updateDisplayName(displayName);
      }
      return _requireUser(credential.user);
    });
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    return _execute(() async {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      return _requireUser(result.user);
    });
  }

  @override
  Future<Either<Failure, AppUser>> signInAnonymously() async {
    return _execute(() async {
      final result = await _firebaseAuth.signInAnonymously();
      return _requireUser(result.user);
    });
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    return _execute(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    });
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return _execute(() async {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No signed-in user');
      }
      final userId = user.uid;
      await _userDataCleanup.deleteAllUserData(userId);
      await user.delete();
      await _googleSignIn.signOut();
      await _databaseService?.clearAll();
      await _storageService?.clear();
    });
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    if (!_isFirebaseReady) {
      return const Left(
        AuthFailure(
          'Firebase is not configured. Run flutterfire configure to enable auth.',
        ),
      );
    }

    try {
      final result = await action();
      if (result is AppUser) {
        await _firestoreUserService.ensureUserProfile(result);
      }
      return Right(result);
    } on FirebaseAuthException catch (e) {
      AppLogger.warning('Firebase auth error: ${e.code}', e);
      return Left(AuthFailure(_mapFirebaseError(e), code: e.code));
    } catch (e) {
      return Left(ErrorMapper.mapException(e));
    }
  }

  AppUser _requireUser(User? user) {
    final mapped = _mapUser(user);
    if (mapped == null) {
      throw const AuthException('Authentication failed');
    }
    return mapped;
  }

  AppUser? _mapUser(User? user) {
    if (user == null) return null;
    return AppUserModel.fromFirebaseUser(user);
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'Please enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found with this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'invalid-credential' =>
        'Incorrect email or password. Please try again.',
      'invalid-login-credentials' =>
        'Incorrect email or password. Please try again.',
      'email-already-in-use' => 'An account already exists with this email.',
      'weak-password' => 'Password must be at least 6 characters.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'requires-recent-login' =>
        'Please sign in again before deleting your account.',
      _ => e.message ?? 'Authentication failed.',
    };
  }
}
