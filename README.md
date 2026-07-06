# TravelMate AI

AI-powered travel planner by **UK Solutions**. Plan trips, track expenses, pack smarter, journal memories, and get AI travel advice — completely free, supported by Google AdMob.

## Features

- Trip planning with offline-first Firestore sync
- AI itinerary, packing, budget, and travel chat
- Expense tracking with charts
- Encrypted document vault
- Weather and currency tools
- Google Maps integration
- Global search with recent queries
- Light and dark themes
- Firebase Analytics and Crashlytics

## Tech stack

- **Flutter** 3.10+ / **Dart** 3.10+
- **GetX** — state, routing, DI
- **Isar** — local database
- **Firebase** — Auth, Firestore, Storage, FCM, Analytics, Crashlytics, Remote Config
- **Google AdMob** — monetization

## Quick start

```bash
flutter pub get
cp .env.example .env
# Configure Firebase — see docs/FIREBASE_SETUP.md
flutter run
```

## Documentation

| Guide | Description |
|-------|-------------|
| [Project Setup](docs/PROJECT_SETUP.md) | Environment and dependencies |
| [Firebase Setup](docs/FIREBASE_SETUP.md) | Firebase project configuration |
| [Architecture](docs/ARCHITECTURE.md) | Clean architecture overview |
| [Folder Structure](docs/FOLDER_STRUCTURE.md) | Code organization |
| [Deployment](docs/DEPLOYMENT.md) | Play Store release guide |

## Architecture

```
lib/
├── app/           # Bootstrap, routes, bindings
├── config/        # Environment config
├── core/          # Services, theme, errors, network
├── features/      # Feature modules (data/domain/presentation)
└── shared/        # Reusable widgets
```

## Package

`com.uksolutions.travelmateai`

## License

Proprietary — UK Solutions. All rights reserved.
