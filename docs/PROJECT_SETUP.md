# TravelMate AI — Project Setup Guide

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | 3.10+ |
| Dart SDK | 3.10+ (bundled with Flutter) |
| Android Studio | Latest stable |
| Xcode (macOS, iOS builds) | 15+ |
| Firebase CLI | Latest |
| FlutterFire CLI | Latest |

## 1. Clone and install

```bash
git clone <repository-url>
cd travelmateai
flutter pub get
```

## 2. Environment variables

```bash
cp .env.example .env
```

Fill in:

- `GEMINI_API_KEY` — Google AI Studio API key for AI features
- `OPENWEATHER_API_KEY` — OpenWeatherMap API key
- `EXCHANGE_RATE_API_KEY` — Exchange rate API key
- `GOOGLE_MAPS_API_KEY` — Google Maps Platform key

## 3. Firebase setup

See [Firebase Setup Guide](FIREBASE_SETUP.md).

## 4. Generate Isar schemas (after model changes)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 5. Run the app

```bash
flutter run
```

## 6. Run tests

```bash
flutter test
flutter analyze
```

## Package name

`com.uksolutions.travelmateai`
