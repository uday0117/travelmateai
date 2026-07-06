# Firebase Setup Guide

TravelMate AI uses Firebase for authentication, cloud sync, analytics, crash reporting, remote config, push notifications, and storage.

## 1. Create a Firebase project

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Create a project named **TravelMate AI**
3. Enable Google Analytics when prompted

## 2. Register Android app

1. Package name: `com.uksolutions.travelmateai`
2. Download `google-services.json`
3. Place it at `android/app/google-services.json`

## 3. Register iOS app (optional)

1. Bundle ID: `com.uksolutions.travelmateai`
2. Download `GoogleService-Info.plist`
3. Add to `ios/Runner/` via Xcode

## 4. FlutterFire configuration

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart`.

## 5. Enable Firebase services

### Authentication
- Email/Password
- Google Sign-In
- Apple Sign-In (iOS)
- Anonymous (guest mode)

### Cloud Firestore
Create collections scoped by user UID. All security rules must filter by `request.auth.uid`.

Example rule pattern:

```
match /users/{userId}/{document=**} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

### Cloud Storage
User-scoped paths: `users/{uid}/...`

### Analytics, Crashlytics, Remote Config, FCM
Enabled automatically via FlutterFire plugins.

## 6. Remote Config defaults

Configure in Firebase Console or via `RemoteConfigService` defaults:

- `enable_ads` — boolean
- `interstitial_cooldown_minutes` — number
- `maintenance_message` — string
- `travel_tips_json` — string

## 7. AdMob

1. Create an AdMob app linked to your Firebase project
2. Replace test ad unit IDs in `lib/core/constants/ad_constants.dart` with production IDs before release
3. Update `APPLICATION_ID` in `android/app/src/main/AndroidManifest.xml`

## 8. App Check (recommended)

Enable App Check in Firebase Console for Android (Play Integrity) and configure debug tokens for development.
