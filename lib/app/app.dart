import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/enums/app_theme_mode.dart';
import '../data/local/app_database.dart';
import '../domain/entities/app_settings.dart';
import '../domain/entities/game_list_item.dart';
import '../domain/entities/game_summary_view_data.dart';
import '../domain/entities/hole_result_view_data.dart';
import '../domain/repositories/app_settings_repository.dart';
import '../domain/repositories/game_repository.dart';
import '../data/repositories/app_settings_repository_impl.dart';
import '../data/repositories/game_repository_impl.dart';
import '../domain/usecases/create_game.dart';
import '../domain/usecases/delete_game.dart';
import '../domain/usecases/duplicate_game.dart';
import '../domain/usecases/finalize_game.dart';
import '../domain/usecases/list_completed_games.dart';
import '../domain/usecases/list_ongoing_games.dart';
import '../domain/usecases/restart_game.dart';
import '../domain/usecases/load_game.dart';
import '../domain/usecases/update_score.dart';
import '../domain/usecases/recalculate_game.dart';
import '../domain/usecases/load_game_summary.dart';
import '../domain/usecases/load_hole_result.dart';
import '../l10n/app_localizations.dart';
import '../services/ad_service.dart';
import '../services/iap_service.dart';
import 'router.dart';
import 'theme/app_theme.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppSettingsRepositoryImpl(db);
});

final appSettingsProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watchSettings();
});

final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService();
  service.preload();
  ref.onDispose(service.dispose);
  return service;
});

final iapServiceProvider = Provider<IapService>((ref) {
  final repository = ref.watch(appSettingsRepositoryProvider);
  final service = IapService(repository);
  service.initialize();
  ref.onDispose(service.dispose);
  return service;
});

final uuidProvider = Provider<Uuid>((ref) {
  return const Uuid();
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final uuid = ref.watch(uuidProvider);
  return GameRepositoryImpl(db, uuid: uuid);
});

final createGameUseCaseProvider = Provider<CreateGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return CreateGameUseCase(repository);
});

final listOngoingGamesUseCaseProvider =
    Provider<ListOngoingGamesUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return ListOngoingGamesUseCase(repository);
});

final listCompletedGamesUseCaseProvider =
    Provider<ListCompletedGamesUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return ListCompletedGamesUseCase(repository);
});

final deleteGameUseCaseProvider = Provider<DeleteGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return DeleteGameUseCase(repository);
});

final restartGameUseCaseProvider = Provider<RestartGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return RestartGameUseCase(repository);
});

final duplicateGameUseCaseProvider = Provider<DuplicateGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return DuplicateGameUseCase(repository);
});

final finalizeGameUseCaseProvider = Provider<FinalizeGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return FinalizeGameUseCase(repository);
});

final ongoingGamesProvider = StreamProvider<List<GameListItem>>((ref) {
  return ref.watch(listOngoingGamesUseCaseProvider).call();
});

final completedGamesProvider = StreamProvider<List<GameListItem>>((ref) {
  return ref.watch(listCompletedGamesUseCaseProvider).call();
});

final loadGameUseCaseProvider = Provider<LoadGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return LoadGameUseCase(repository);
});

final updateScoreUseCaseProvider = Provider<UpdateScoreUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return UpdateScoreUseCase(repository);
});

final recalculateGameUseCaseProvider = Provider<RecalculateGameUseCase>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return RecalculateGameUseCase(repository);
});

final loadHoleResultUseCaseProvider = Provider<LoadHoleResultUseCase>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LoadHoleResultUseCase(db);
});

final loadGameSummaryUseCaseProvider = Provider<LoadGameSummaryUseCase>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LoadGameSummaryUseCase(db);
});

final holeResultProvider = StreamProvider.family<HoleResultViewData?,
    ({String gameId, int holeNumber})>((ref, params) {
  return ref.watch(loadHoleResultUseCaseProvider).watch(
        gameId: params.gameId,
        holeNumber: params.holeNumber,
      );
});

final gameSummaryProvider =
    StreamProvider.family<GameSummaryViewData?, String>((ref, gameId) {
  return ref.watch(loadGameSummaryUseCaseProvider).watch(gameId);
});

class BestOneGolfApp extends ConsumerWidget {
  const BestOneGolfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final router = ref.watch(appRouterProvider);

    return settingsAsync.when(
      data: (settings) {
        final themeMode = switch (settings.themeMode) {
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
          AppThemeMode.system => ThemeMode.system,
        };

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'BestOneGolf',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: router,
          locale: Locale(settings.language.code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: Text('App init error: $error'),
          ),
        ),
      ),
    );
  }
}
