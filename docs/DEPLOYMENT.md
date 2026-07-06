# Deployment Guide — Google Play Store

## Pre-release checklist

- [ ] Replace AdMob test IDs in `lib/core/constants/ad_constants.dart`
- [ ] Replace test `APPLICATION_ID` in `AndroidManifest.xml`
- [ ] Configure production Firebase project
- [ ] Update privacy policy and terms URLs in `AppConstants`
- [ ] Add app icon and splash assets
- [ ] Configure release signing (see below)
- [ ] Run `flutter analyze` and `flutter test`
- [ ] Test release build on physical devices

## Versioning

Update in `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

- `1.0.0` — user-visible version name
- `1` — version code (increment for each Play Store upload)

## Android release signing

1. Generate a keystore:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Copy `android/key.properties.example` to `android/key.properties` and fill in values.

3. Build release APK/AAB:

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Play Store assets

Place listing assets in `store_assets/`:

```
store_assets/
├── icon/           # 512×512 Play Store icon
├── feature_graphic/ # 1024×500 feature graphic
├── screenshots/    # Phone and tablet screenshots
└── README.md
```

## Adaptive icon (Android)

Replace launcher assets in:

- `android/app/src/main/res/mipmap-*/ic_launcher.png`
- `android/app/src/main/res/drawable/ic_launcher_foreground.xml`
- `android/app/src/main/res/values/colors.xml` (background color)

Or use `flutter_launcher_icons` with your brand assets.

## Privacy and compliance

- In-app privacy policy: Settings → Privacy Policy
- Data safety form: declare Firebase Auth, Firestore, Analytics, AdMob, location (maps)
- Target API: follows Flutter `targetSdkVersion`

## Post-launch

- Monitor Firebase Crashlytics
- Tune Remote Config ad frequency
- Review Firebase Analytics funnels
