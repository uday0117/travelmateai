# Architecture Guide

TravelMate AI follows **Clean Architecture** with a **feature-first** folder structure.

## Layers

```
Presentation  →  Controllers, Pages, Widgets (GetX)
Domain        →  Entities, Repository interfaces, Use cases
Data          →  Repositories, Data sources, Isar models
```

## State management

- **GetX** for reactive state, routing, and dependency injection
- `InitialBinding` registers global services
- Feature bindings register feature-specific controllers

## Offline-first sync

```
User action → Isar (local) → Sync queue → Firestore → Update local cache
```

`SyncService` coordinates background sync when connectivity is restored.

## Core services

| Service | Responsibility |
|---------|----------------|
| `DatabaseService` | Isar local database |
| `SyncService` | Cloud sync orchestration |
| `AnalyticsService` | Firebase Analytics events |
| `CrashReportingService` | Firebase Crashlytics |
| `AdMobService` | Google AdMob (all ad formats) |
| `AiService` | AI provider abstraction |
| `ErrorHandler` | Centralized user-facing errors |
| `SearchService` | Recent search persistence |

## AI architecture

```
UI → AiService → AiProvider (interface) → GeminiAiProvider
```

Prompts live in `lib/core/services/ai/ai_prompts.dart` — never in widgets.

## Security

- All Firestore queries filter by authenticated UID
- Document notes encrypted via `EncryptionService`
- Biometric gate on document vault

## Theming

- Light and dark themes via `AppTheme`
- User preference stored in `ThemeController`
