import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelmateai/features/auth/domain/entities/app_user.dart';

/// Data model mapping Firebase User to domain entity.
class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    super.email,
    super.displayName,
    super.photoUrl,
    super.isAnonymous = false,
    super.provider = AuthProviderType.email,
  });

  factory AppUserModel.fromFirebaseUser(User user) {
    return AppUserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
      provider: _mapProvider(user),
    );
  }

  static AuthProviderType _mapProvider(User user) {
    if (user.isAnonymous) return AuthProviderType.anonymous;

    for (final info in user.providerData) {
      switch (info.providerId) {
        case 'google.com':
          return AuthProviderType.google;
        case 'apple.com':
          return AuthProviderType.apple;
      }
    }
    return AuthProviderType.email;
  }
}
