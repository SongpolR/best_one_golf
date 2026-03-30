import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/app/router.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/features/create_game/presentation/create_game_screen.dart';
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
      initialLocation: '/create-game',
      routes: [
        GoRoute(
          path: '/create-game',
          builder: (context, state) => const CreateGameScreen(),
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

  Finder scrollable = find.byType(Scrollable).first;

  Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Create Game screen renders base sections', (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    expect(find.text('New Game'), findsOneWidget);
    expect(find.text('Players'), findsOneWidget);
    expect(find.text('Mode'), findsOneWidget);
    expect(find.text('Rules'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('holeSetupSectionTitle')),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    await scrollUntilVisible(tester, find.text('Start Game'));
    expect(find.text('Start Game'), findsOneWidget);
  });

  testWidgets('can add player up to more than initial count', (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    expect(find.text('Player 1'), findsOneWidget);
    expect(find.text('Player 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('addPlayerButton')));
    await tester.pump();

    expect(find.text('Player 3'), findsOneWidget);
  });

  testWidgets('switching to team mode shows team section', (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('teamModeRadio')));
    await tester.pumpAndSettle();

    expect(find.text('Teams'), findsOneWidget);
    expect(find.text('Team 1'), findsOneWidget);

    await scrollUntilVisible(tester, find.text('Add Team'));
    expect(find.byKey(const Key('addTeamButton')), findsOneWidget);
  });

  testWidgets('submit invalid form shows validation error', (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    await scrollUntilVisible(tester, find.text('Start Game'));
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    expect(find.text('Game title is required.'), findsOneWidget);
  });

  testWidgets('submit valid form navigates to score entry', (tester) async {
    final fakeRepository = FakeGameRepository(
      createdGameId: 'game-999',
      gameAggregate: fakeGameAggregate(gameId: 'game-999'),
    );

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('createGameTitleField')), 'Saturday Match');
    await tester.enterText(find.byType(TextField).at(1), 'Alice');
    await tester.enterText(find.byType(TextField).at(2), 'Bob');
    await tester.pumpAndSettle();

    final startGameFinder = find.byKey(const Key('startGameButton'));
    await tester.scrollUntilVisible(
      startGameFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(startGameFinder);
    await tester.pumpForNavigation();

    expect(find.text('Score Entry'), findsOneWidget);
    expect(find.text('Saturday Match'), findsOneWidget);
    expect(find.textContaining('Hole 1 / 18'), findsOneWidget);
  });
}
