import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/local/app_database.dart';
import '../data/repositories/app_settings_repository_impl.dart';
import '../data/repositories/game_repository_impl.dart';
import '../domain/entities/app_settings.dart';
import '../domain/entities/game_list_item.dart';
import '../domain/repositories/app_settings_repository.dart';
import '../domain/repositories/game_repository.dart';
import '../domain/usecases/create_game.dart';
import '../domain/usecases/delete_game.dart';
import '../domain/usecases/finalize_game.dart';
import '../domain/usecases/list_completed_games.dart';
import '../domain/usecases/list_ongoing_games.dart';
import '../domain/usecases/restart_game.dart';
import '../domain/usecases/load_game.dart';
import '../domain/usecases/update_score.dart';
import '../domain/usecases/recalculate_game.dart';
import '../l10n/app_localizations.dart';
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

class BestOneGolfApp extends ConsumerWidget {
  const BestOneGolfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final router = ref.watch(appRouterProvider);

    return settingsAsync.when(
      data: (settings) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'BestOneGolf',
          theme: AppTheme.light(),
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
