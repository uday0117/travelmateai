/// Google OAuth client IDs used by Google Sign-In + Firebase Auth.
///
/// [webClientId] must be the Web client (client_type: 3) from Firebase /
/// Google Cloud Console. Passing it as `serverClientId` is required on Android
/// so Google Sign-In returns an ID token Firebase can verify.
abstract final class GoogleAuthConfig {
  /// Web OAuth client from `android/app/google-services.json` (client_type: 3).
  static const String webClientId =
      '872642314665-s7au3i4hp9oru0mhtjuc6i47mpgsack2.apps.googleusercontent.com';

  /// iOS OAuth client from Firebase (client_type: 2).
  static const String iosClientId =
      '872642314665-gtc54adk383eaql8aa3t12db0400tggv.apps.googleusercontent.com';

  /// URL scheme required in iOS Info.plist for Google Sign-In redirects.
  static const String iosReversedClientId =
      'com.googleusercontent.apps.872642314665-gtc54adk383eaql8aa3t12db0400tggv';
}
