# Folder Structure Guide

```
travelmateai/
├── android/                 # Android native project
├── ios/                     # iOS native project
├── assets/
│   ├── images/              # Raster images
│   ├── icons/               # SVG / icon assets
│   ├── lottie/              # Lottie animations
│   ├── fonts/               # Custom fonts
│   └── illustrations/       # Empty states, onboarding art
├── docs/                    # Project documentation
├── store_assets/            # Play Store listing assets
├── lib/
│   ├── app/                 # App entry, routes, bootstrap, bindings
│   ├── config/              # Environment configuration
│   ├── core/
│   │   ├── constants/       # App-wide constants
│   │   ├── database/        # Isar schema registry
│   │   ├── errors/          # Failures, exceptions, ErrorHandler
│   │   ├── extensions/      # Dart extensions
│   │   ├── logging/         # AppLogger
│   │   ├── network/         # Dio client, connectivity
│   │   ├── repositories/    # Base repository patterns
│   │   ├── services/        # Shared services (AI, ads, sync, etc.)
│   │   ├── theme/           # Colors, spacing, themes
│   │   └── usecases/        # Base use case
│   ├── features/            # Feature modules
│   │   ├── auth/
│   │   ├── trips/
│   │   ├── expenses/
│   │   ├── packing/
│   │   ├── journal/
│   │   ├── documents/
│   │   ├── ai/
│   │   ├── explore/
│   │   ├── home/
│   │   ├── maps/
│   │   ├── search/
│   │   ├── settings/
│   │   ├── legal/
│   │   ├── splash/
│   │   └── onboarding/
│   └── shared/              # Reusable widgets
└── test/                    # Unit and widget tests
```

## Feature module structure

Each feature typically contains:

```
feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── bindings/
    ├── controllers/
    ├── pages/
    └── widgets/
```

## Naming conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | snake_case | `trip_detail_page.dart` |
| Classes | PascalCase | `TripDetailPage` |
| Variables | camelCase | `selectedTrip` |
