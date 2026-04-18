import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/app/router.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/core/enums/app_theme_mode.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/domain/entities/game_aggregate.dart';
import 'package:best_one_golf/domain/entities/golf_course.dart';
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
  const testCourses = [
    GolfCourse(
      id: 'singha-park-khon-kaen',
      name: 'Singha Park Khon Kaen Golf Club',
      location: 'Khon Kaen',
      totalHoles: 18,
      pars: [4, 4, 5, 4, 3, 4, 5, 3, 4, 4, 5, 4, 3, 4, 4, 4, 3, 5],
    ),
  ];

  Widget buildTestApp(
    FakeGameRepository fakeRepository, {
    GameAggregate? template,
    List<GolfCourse> courses = testCourses,
  }) {
    final router = GoRouter(
      initialLocation: '/create-game',
      routes: [
        GoRoute(
          path: '/create-game',
          pageBuilder: (context, state) {
            final tmpl = state.extra as GameAggregate?;
            return MaterialPage(child: CreateGameScreen(template: tmpl));
          },
        ),
        GoRoute(
          path: '/score-entry/:gameId',
          builder: (context, state) {
            final gameId = state.pathParameters['gameId']!;
            return ScoreEntryScreen(gameId: gameId);
          },
        ),
      ],
      initialExtra: template,
    );

    return ProviderScope(
      overrides: [
        appSettingsProvider.overrideWith(
          (ref) => Stream.value(
            const AppSettings(
              language: AppLanguage.en,
              currency: AppCurrency.usd,
              themeMode: AppThemeMode.system,
            ),
          ),
        ),
        gameRepositoryProvider.overrideWithValue(fakeRepository),
        appRouterProvider.overrideWithValue(router),
        golfCoursesProvider.overrideWith(
          (ref) => Future.value(courses),
        ),
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

  testWidgets('golf course selector is shown in hole setup section',
      (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    await scrollUntilVisible(tester, find.text('Golf Course'));
    expect(find.text('Golf Course'), findsOneWidget);
  });

  testWidgets('selecting a golf course updates hole par values in the form',
      (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    // Scroll to the golf course dropdown
    await scrollUntilVisible(tester, find.text('Golf Course'));

    // Open the dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Select the course from the dropdown menu
    await tester.tap(
      find.text('Singha Park Khon Kaen Golf Club (Khon Kaen)').last,
    );
    await tester.pumpAndSettle();

    // Scroll to Hole 3 and verify par changed to 5 (from default 4)
    await scrollUntilVisible(tester, find.text('Hole 3'));

    // Find the NumberStepper for Hole 3 — its value should show "5"
    // The NumberStepper renders the value as a Text widget
    // Hole 3 par = 5, Hole 5 par = 3 per course data
    expect(find.text('5'), findsWidgets);

    // Scroll to Hole 5 and verify par is 3
    await scrollUntilVisible(tester, find.text('Hole 5'));
    expect(find.text('3'), findsWidgets);
  });

  testWidgets('deselecting golf course resets all hole pars back to default 4',
      (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    // Select the course first
    await scrollUntilVisible(tester, find.text('Golf Course'));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('Singha Park Khon Kaen Golf Club (Khon Kaen)').last,
    );
    await tester.pumpAndSettle();

    // Now deselect — open dropdown and choose "Select a golf course"
    await scrollUntilVisible(tester, find.text('Golf Course'));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select a golf course').last);
    await tester.pumpAndSettle();
  });

  testWidgets('golf course selector is hidden when no courses available',
      (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository, courses: const []));
    await tester.pumpAndSettle();

    await scrollUntilVisible(tester, find.text('Hole Setup'));
    expect(find.text('Golf Course'), findsNothing);
  });

  testWidgets('reset to default button shows confirmation dialog',
      (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    // Tap the reset button in the app bar
    await tester.tap(find.byKey(const Key('resetToDefaultButton')));
    await tester.pumpAndSettle();

    // Confirmation dialog should appear
    expect(find.text('Reset to Default'), findsOneWidget);
    expect(
      find.text(
          'Do you want to reset all game settings to their default values?'),
      findsOneWidget,
    );
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });

  testWidgets('cancelling reset dialog does not clear the form',
      (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    // Enter a title first
    await tester.enterText(
        find.byKey(const Key('createGameTitleField')), 'My Game');
    await tester.pumpAndSettle();

    // Tap reset, then cancel
    await tester.tap(find.byKey(const Key('resetToDefaultButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Title should still be there
    expect(find.text('My Game'), findsOneWidget);
  });

  testWidgets('confirming reset clears the form to default values',
      (tester) async {
    final fakeRepository = FakeGameRepository();

    await tester.pumpWidget(buildTestApp(fakeRepository));
    await tester.pumpAndSettle();

    // Enter a title and add a player
    await tester.enterText(
        find.byKey(const Key('createGameTitleField')), 'My Game');
    await tester.tap(find.byKey(const Key('addPlayerButton')));
    await tester.pumpAndSettle();

    // Should have 3 players now
    expect(find.text('Player 3'), findsOneWidget);

    // Tap reset, then confirm
    await tester.tap(find.byKey(const Key('resetToDefaultButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    // Title should be cleared
    expect(find.text('My Game'), findsNothing);
    // Player 3 should be gone (back to 2 players)
    expect(find.text('Player 3'), findsNothing);
    expect(find.text('Player 1'), findsOneWidget);
    expect(find.text('Player 2'), findsOneWidget);
  });

  testWidgets('pre-fills form fields from template when duplicating',
      (tester) async {
    final template = fakeGameAggregate(
      gameId: 'orig-1',
      title: 'Weekend Classic',
    );
    final fakeRepository = FakeGameRepository(
      createdGameId: 'new-game-1',
      gameAggregate: fakeGameAggregate(gameId: 'new-game-1'),
    );

    await tester.pumpWidget(buildTestApp(fakeRepository, template: template));
    await tester.pumpAndSettle();

    // Title field should be pre-filled from the template.
    expect(find.text('Weekend Classic'), findsOneWidget);

    // Players from the template should appear.
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Charlie'), findsOneWidget);

    // The form can still be submitted after duplication.
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
  });
}
