# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter analyze          # Static analysis
flutter test             # Run all tests
flutter test test/path/to/test_file.dart   # Run a single test file
flutter run              # Run on connected device/emulator
flutter pub run build_runner build         # Regenerate Drift DB + localization code
flutter pub run build_runner build --delete-conflicting-outputs  # Force regenerate
```

> After modifying any Drift table definitions or adding `.g.dart`-backed files, run `build_runner build`.

## Architecture

This is a Flutter golf score tracking app that calculates per-hole and final monetary settlements across game modes.

### Layer structure

```
lib/
├── app/           # Router (go_router), theme, app widget
├── core/          # Shared enums: GameMode, Currency, Language
├── domain/        # Pure business logic — no Flutter/Drift imports
│   ├── entities/  # Data models (Game, Player, Team, HoleScore, etc.)
│   ├── repositories/  # Abstract interfaces
│   ├── services/  # Calculation engines (GameCalculator, IndividualCalculator, TeamCalculator, SettlementCalculator, GameSetupValidator)
│   └── usecases/  # 11 use cases; one action per class
├── data/
│   ├── local/     # Drift database: tables, DAOs, AppDatabase
│   └── repositories/  # Concrete implementations of domain interfaces
├── features/      # Per-screen: controller (Riverpod Notifier) + screen widget
│   └── {feature}/
│       ├── {feature}_controller.dart
│       └── {feature}_screen.dart
├── shared/        # Reusable widgets
└── l10n/          # ARB files — English (en) and Thai (th)
```

### State management

Riverpod (`flutter_riverpod`). Screens read providers from `ref`; side effects go through `NotifierProvider` controllers. Avoid putting business logic in widgets or controllers — delegate to use cases and services in `domain/`.

### Database

Drift (type-safe SQLite ORM). Schema is at version 4. Tables:
- `GamesTable`, `PlayersTable`, `TeamsTable`, `GameRuleSettingsTable`
- `HoleConfigsTable`, `HoleScoresTable`
- `ComputedHoleResultsTable`, `SettlementSnapshotsTable` — store pre-calculated JSON
- `AppSettingsTable`

DAOs: `AppSettingsDao`, `GamesDao`, `ScoreEntryDao`, `HistoryDao`, `CalculationDao`, `ResultViewDao`.

Migrations are step-by-step (v1→v2→v3→v4) in `AppDatabase`. Always add a migration step when changing the schema — never edit existing migrations.

### Routing

`go_router` defined in `lib/app/router.dart`. Routes: `/` (home), `/create-game`, `/score-entry/:gameId`, `/hole-result/:gameId/:holeNumber`, `/game-summary/:gameId`, `/history`, `/settings`.

### Localization

Supported languages: English (`en`), Thai (`th`). ARB files live in `lib/l10n/`. Config in `l10n.yaml`. Generated code is under `lib/l10n/` — do not edit generated files directly.

### Calculation flow

1. Scores entered per hole in `ScoreEntryScreen`
2. Use cases call `GameCalculator` → delegates to `IndividualCalculator` or `TeamCalculator`
3. Results stored in `ComputedHoleResultsTable` as JSON movements
4. `SettlementCalculator` aggregates all holes into final money flows stored in `SettlementSnapshotsTable`
