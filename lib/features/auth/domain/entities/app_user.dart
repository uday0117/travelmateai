import 'package:equatable/equatable.dart';

/// Authentication provider types.
enum AuthProviderType {
  email,
  google,
  apple,
  anonymous,
}

/// Domain user entity.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
    this.provider = AuthProviderType.email,
  });

  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
  final AuthProviderType provider;

  String get initials {
    final name = displayName ?? email ?? 'G';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, isAnonymous, provider];
}
