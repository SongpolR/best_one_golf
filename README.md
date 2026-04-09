# BestOneGolf

A Flutter app for tracking golf scores and calculating per-hole monetary settlements across multiple game modes and scoring rules.

---

## What It Does

BestOneGolf is built for casual golfers who play rounds with monetary side bets. You configure the game once (players, rules, hole setups), enter strokes hole-by-hole, and the app handles all the math — telling you exactly who owes whom at the end.

Key capabilities:
- **Individual** and **Team** game modes
- Per-hole monetary settlements with **Best One** and **Best Two** rules
- **Turbo** (×2) and **Birdie Bonus** (×2) multipliers per hole
- Full game history with ongoing / completed separation and paginated load-more
- Game summary with final money flows and per-hole breakdown
- Duplicate a previous game as a template for a new one
- Remove Ads via one-time in-app purchase

Supported languages: **English** and **Thai**. Supported currencies: **USD** and **THB**.

---

## Screens

| Route | Screen | Purpose |
|---|---|---|
| `/` | Home | Recent games, New Game button, navigation hub |
| `/create-game` | Create Game | Title, players, mode, teams, rules, per-hole config |
| `/score-entry/:gameId` | Score Entry | Enter strokes hole-by-hole; swipe to navigate holes |
| `/hole-result/:gameId/:holeNumber` | Hole Result | Per-hole calculation results and movements |
| `/game-summary/:gameId` | Game Summary | Final totals and simplified who-pays-whom settlements |
| `/history` | History | Paginated ongoing and completed game lists |
| `/settings` | Settings | Language, currency, theme, Remove Ads purchase |

---

## Game Rules

### Modes

**Individual** — every player is compared directly against every other player on each hole.

**Team** — players are divided into teams. The best (lowest) score from each team competes against the equivalent-ranked score on the opposing team.

### Rules

**Best One** — the single best (lowest) score per side is compared. The winning side collects the configured amount from the losing side. Available in both Individual and Team modes.

**Best Two** — the second-best score per team is compared. Only available in Team mode and only when Best One is also enabled. Can share the same amount as Best One or use a separate amount.

### Multipliers (per hole)

**Turbo ×2** — the bet amount for that hole is doubled.

**Birdie Bonus ×2** — if the deciding score is below par, the amount is doubled again. Stacks with Turbo (possible multipliers: ×1, ×2, ×4).

### Calculation Flow

```
Scores entered
  → GameCalculator routes to IndividualCalculator or TeamCalculator
  → MoneyMovement list generated per hole
  → Multipliers applied (Turbo, Birdie Bonus)
  → SettlementCalculator aggregates across all holes
  → Stored as pre-computed JSON in DB
  → Displayed in Hole Result and Game Summary screens
```

---

## Tech Stack

| Concern | Library |
|---|---|
| Framework | Flutter ≥ 3.5 / Dart ≥ 3.5 |
| State management | `flutter_riverpod` ^2.5 |
| Navigation | `go_router` ^14 |
| Database | `drift` ^2.20 (SQLite ORM) |
| Localization | `flutter_localizations` + ARB |
| Fonts | `google_fonts` ^6 |
| Ads | `google_mobile_ads` ^5 |
| IAP | `in_app_purchase` ^3 |
| Async utilities | `rxdart` ^0.28 |
| IDs | `uuid` ^4 |

---

## Architecture

Clean Architecture with three main layers and no cross-layer imports pointing inward.

```
lib/
├── app/            # Router, theme, Riverpod provider wiring
├── core/           # Shared enums (GameMode, Currency, Language, etc.)
├── domain/         # Pure Dart — no Flutter or Drift imports
│   ├── entities/   # Immutable data models
│   ├── repositories/   # Abstract interfaces
│   ├── services/   # Calculation engines
│   └── usecases/   # 12 single-responsibility use cases
├── data/
│   ├── local/      # Drift tables, DAOs, AppDatabase (schema v6)
│   └── repositories/   # Concrete repository implementations
├── features/       # One folder per screen
│   └── {name}/
│       ├── {name}_controller.dart   # AutoDisposeNotifier
│       └── {name}_screen.dart       # ConsumerWidget or ConsumerStatefulWidget
├── shared/         # Reusable widgets (AppScaffold, NumberStepper, etc.)
├── services/       # AdService, IapService
└── l10n/           # ARB files + generated AppLocalizations
```

Business logic lives exclusively in `domain/`. Controllers are thin — they call use cases and hold UI state only.

### Database (Drift, schema v6)

| Table | Purpose |
|---|---|
| `GamesTable` | Game metadata and status |
| `PlayersTable` | Players per game |
| `TeamsTable` | Teams per game |
| `GameRuleSettingsTable` | Rule flags and amounts |
| `HoleConfigsTable` | Par, Turbo, Birdie Bonus per hole |
| `HoleScoresTable` | Raw stroke entries |
| `ComputedHoleResultsTable` | Pre-calculated hole results (JSON) |
| `SettlementSnapshotsTable` | Final game settlements (JSON) |
| `AppSettingsTable` | User preferences |

Migrations are step-by-step (v1→v2→…→v6). Never edit existing migration steps.

---

## Monetization

**Interstitial ads** are shown before the Create Game screen loads (both New Game and Duplicate flows). If an ad fails to load, a 5-second countdown dialog appears before continuing.

**Remove Ads** is a non-consumable one-time IAP (`remove_ads` product ID). Once purchased, the `adsRemoved` flag is persisted in `AppSettingsTable` and all ad gates are bypassed. Restore Purchases is available for users who reinstall.

---

## Development

### Prerequisites

- Flutter ≥ 3.5
- Connected device or emulator

### Commands

```bash
flutter pub get                                          # Install dependencies
dart run build_runner build --delete-conflicting-outputs # Regenerate Drift + l10n code
flutter analyze                                          # Static analysis
flutter test                                             # Run all tests
flutter run                                              # Run on device
```

> Re-run `build_runner build` after any change to Drift table definitions or ARB localization files.

### Adding a migration

When changing the schema, bump `schemaVersion` in `AppDatabase` and add a new `MigrationStep` at the end of the migration list. Never modify existing steps.

---

## Localization

ARB files live in `lib/l10n/`. The template is `app_en.arb`; `app_th.arb` provides Thai translations.

To add a new string:
1. Add the key and value to both ARB files.
2. Run `dart run build_runner build` to regenerate `AppLocalizations`.
3. Use `AppLocalizations.of(context)!.yourKey` in widgets.

---

## Testing

```
test/
├── unit/
│   ├── core/               # Enum helpers, currency formatter
│   ├── domain/
│   │   ├── calculation/    # IndividualCalculator, TeamCalculator, multipliers, settlements
│   │   ├── usecases/       # Each use case tested in isolation
│   │   └── validation/     # GameSetupValidator
│   └── features/
│       └── score_entry/    # ScoreEntryController unit tests
├── widget/
│   └── features/           # Widget tests per screen
├── fakes/                  # FakeGameRepository, FakeAppSettingsRepository, FakeIapService
└── helpers/                # pumpApp utility with default provider overrides
```
