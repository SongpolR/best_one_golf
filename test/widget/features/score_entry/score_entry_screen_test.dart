import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/app/router.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/features/score_entry/presentation/score_entry_screen.dart';
import 'package:best_one_golf/l10n/app_localizations.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget buildTestApp(FakeGameRepository fakeRepository) {
    final router = GoRouter(
      initialLocation: '/score-entry/game-1',
      routes: [
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

  testWidgets('Score entry screen renders game and players', (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('Score Entry'), findsOneWidget);
    expect(find.text('Saturday Match'), findsOneWidget);
    expect(find.text('Hole 1 / 18'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('Entering score updates repository and hole becomes partial',
      (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('scoreField_1_p1')), '4');
    await tester.pumpAndSettle();

    expect(find.text('1'), findsWidgets);
  });

  testWidgets('Next button goes to next hole', (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('nextHoleButton')));
    await tester.pumpAndSettle();

    expect(find.text('Hole 2 / 18'), findsOneWidget);
  });

  testWidgets('Prev button goes back to previous hole', (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('nextHoleButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('prevHoleButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('scoreEntryHoleLabel')), findsOneWidget);
    expect(find.text('Hole 1 / 18'), findsOneWidget);
  });

  testWidgets('Tap hole indicator jumps to selected hole', (tester) async {
    final repository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );

    await tester.pumpWidget(buildTestApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('7').last);
    await tester.pumpAndSettle();

    expect(find.text('Hole 7 / 18'), findsOneWidget);
  });
}
