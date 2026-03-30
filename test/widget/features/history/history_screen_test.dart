import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/app/router.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/features/history/presentation/history_screen.dart';
import 'package:best_one_golf/features/score_entry/presentation/score_entry_screen.dart';
import 'package:best_one_golf/l10n/app_localizations.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Widget buildTestApp(FakeGameRepository fakeRepository) {
    final router = GoRouter(
      initialLocation: '/history',
      routes: [
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/score-entry/:gameId',
          builder: (context, state) {
            final gameId = state.pathParameters['gameId']!;
            return ScoreEntryScreen(gameId: gameId);
          },
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        appSettingsProvider.overrideWith(
          (ref) => Stream.value(
            const AppSettings(
              language: AppLanguage.en,
              currency: AppCurrency.usd,
            ),
          ),
        ),
        gameRepositoryProvider.overrideWithValue(fakeRepository),
        appRouterProvider.overrideWithValue(router),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }

  testWidgets('History screen renders ongoing and completed games',
      (tester) async {
    final repository = FakeGameRepository(
      ongoingGames: [
        fakeGameListItem(id: '1', title: 'Ongoing Match'),
      ],
      completedGames: [
        fakeGameListItem(
          id: '2',
          title: 'Completed Match',
          status: 'completed',
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('History'), findsOneWidget);
    expect(find.text('Ongoing').first, findsOneWidget);
    expect(find.text('Completed').first, findsOneWidget);
    expect(find.text('Ongoing Match'), findsOneWidget);
    expect(find.text('Completed Match'), findsOneWidget);
  });

  testWidgets('Continue button navigates to score entry', (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(gameId: 'game-1'),
      ongoingGames: [
        fakeGameListItem(id: 'game-1', title: 'Ongoing Match'),
      ],
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpForNavigation();

    expect(find.text('Score Entry'), findsOneWidget);
    expect(find.text('Saturday Match'), findsOneWidget);
    expect(find.textContaining('Hole 1 / 18'), findsOneWidget);
  });

  testWidgets('View button navigates to score entry', (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(gameId: 'game-2'),
      completedGames: [
        fakeGameListItem(
          id: 'game-2',
          title: 'Completed Match',
          status: 'completed',
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('View'));
    await tester.pumpForNavigation();

    expect(find.text('Score Entry'), findsOneWidget);
    expect(find.text('Saturday Match'), findsOneWidget);
    expect(find.textContaining('Hole 1 / 18'), findsOneWidget);
  });

  testWidgets('Delete button shows confirmation dialog', (tester) async {
    final repository = FakeGameRepository(
      ongoingGames: [
        fakeGameListItem(id: 'game-1', title: 'Ongoing Match'),
      ],
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Game'), findsOneWidget);
    expect(find.text('Do you want to delete this game permanently?'),
        findsOneWidget);
  });

  testWidgets('Confirm delete removes game', (tester) async {
    final repository = FakeGameRepository(
      ongoingGames: [
        fakeGameListItem(id: 'game-1', title: 'Ongoing Match'),
      ],
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repository.deletedGameId, 'game-1');
    expect(find.text('Ongoing Match'), findsNothing);
  });

  testWidgets('Restart button shows confirmation dialog', (tester) async {
    final repository = FakeGameRepository(
      ongoingGames: [
        fakeGameListItem(id: 'game-1', title: 'Ongoing Match'),
      ],
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Restart'));
    await tester.pumpAndSettle();

    expect(find.text('Restart Game'), findsOneWidget);
    expect(
      find.text('Do you want to create a new game using the same settings?'),
      findsOneWidget,
    );
  });

  testWidgets('Confirm restart navigates to new restarted game',
      (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(gameId: 'restarted-game-1'),
      ongoingGames: [
        fakeGameListItem(id: 'game-1', title: 'Ongoing Match'),
      ],
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Restart'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Restart'));
    await tester.pumpForNavigation();

    expect(repository.restartedFromGameId, 'game-1');
    expect(find.text('Score Entry'), findsOneWidget);
    expect(find.text('Saturday Match'), findsOneWidget);
    expect(find.textContaining('Hole 1 / 18'), findsOneWidget);
  });
}
