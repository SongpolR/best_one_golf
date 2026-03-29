import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/features/game_summary/presentation/game_summary_screen.dart';
import '../../../fakes/fake_game_repository.dart';
import '../../../fakes/fake_load_game_summary_usecase.dart';
import '../../../fakes/fake_load_hole_result_usecase.dart';
import '../../../helpers/result_view_fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp({
    required FakeGameRepository gameRepository,
    required FakeLoadHoleResultUseCase holeResultUseCase,
    required FakeLoadGameSummaryUseCase gameSummaryUseCase,
  }) {
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
        gameRepositoryProvider.overrideWithValue(gameRepository),
        holeResultProvider((gameId: 'game-1', holeNumber: 1)).overrideWith(
          (ref) => Stream.value(holeResultUseCase.initialValue),
        ),
        gameSummaryProvider('game-1').overrideWith(
          (ref) => Stream.value(gameSummaryUseCase.initialValue),
        ),
      ],
      child: const MaterialApp(
        home: GameSummaryScreen(
          gameId: 'game-1',
        ),
      ),
    );
  }

  testWidgets('renders totals and readable settlements with names',
      (tester) async {
    final gameRepository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );
    final holeResultUseCase = FakeLoadHoleResultUseCase(
      initialValue: fakeHoleResultViewData(),
    );
    final gameSummaryUseCase = FakeLoadGameSummaryUseCase(
      initialValue: fakeGameSummaryViewData(),
    );

    await tester.pumpWidget(
      buildTestApp(
        gameRepository: gameRepository,
        holeResultUseCase: holeResultUseCase,
        gameSummaryUseCase: gameSummaryUseCase,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Game Summary'), findsOneWidget);
    expect(find.text('Saturday Match'), findsOneWidget);
    expect(find.text('Totals by Player'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Charlie'), findsOneWidget);
    expect(find.text('Settlements'), findsOneWidget);
    expect(find.text('Bob pays Alice'), findsOneWidget);
  });

  testWidgets('shows hole list and opens hole result sheet on tap',
      (tester) async {
    final gameRepository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );
    final holeResultUseCase = FakeLoadHoleResultUseCase(
      initialValue: fakeHoleResultViewData(),
    );
    final gameSummaryUseCase = FakeLoadGameSummaryUseCase(
      initialValue: fakeGameSummaryViewData(),
    );

    await tester.pumpWidget(
      buildTestApp(
        gameRepository: gameRepository,
        holeResultUseCase: holeResultUseCase,
        gameSummaryUseCase: gameSummaryUseCase,
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Holes'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Holes'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('summaryHole_1')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('summaryHole_1')));
    await tester.pumpAndSettle();

    expect(find.text('Hole 1 Result'), findsOneWidget);
  });
}
