import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/core/enums/app_currency.dart';
import 'package:best_one_golf/core/enums/app_language.dart';
import 'package:best_one_golf/domain/entities/app_settings.dart';
import 'package:best_one_golf/features/hole_result/presentation/hole_result_sheet.dart';
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
        home: Scaffold(
          body: HoleResultSheet(
            gameId: 'game-1',
            holeNumber: 1,
          ),
        ),
      ),
    );
  }

  testWidgets('renders summary mode with mapped player names', (tester) async {
    final gameRepository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );
    final holeResultUseCase = FakeLoadHoleResultUseCase(
      initialValue: fakeHoleResultViewData(),
    );
    final gameSummaryUseCase = FakeLoadGameSummaryUseCase();

    await tester.pumpWidget(
      buildTestApp(
        gameRepository: gameRepository,
        holeResultUseCase: holeResultUseCase,
        gameSummaryUseCase: gameSummaryUseCase,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hole 1 Result'), findsOneWidget);
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Player Net'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('switches to detail mode and shows movement list',
      (tester) async {
    final gameRepository = FakeGameRepository(
      gameAggregate: fakeGameAggregate(),
    );
    final holeResultUseCase = FakeLoadHoleResultUseCase(
      initialValue: fakeHoleResultViewData(),
    );
    final gameSummaryUseCase = FakeLoadGameSummaryUseCase();

    await tester.pumpWidget(
      buildTestApp(
        gameRepository: gameRepository,
        holeResultUseCase: holeResultUseCase,
        gameSummaryUseCase: gameSummaryUseCase,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Detail'));
    await tester.pumpAndSettle();

    expect(find.text('Player Movements'), findsOneWidget);
    expect(find.text('Bob → Alice'), findsOneWidget);
  });

  testWidgets('shows team data when result contains team movements',
      (tester) async {
    final gameRepository = FakeGameRepository(
      gameAggregate: fakeGameAggregateForTeams(),
    );
    final holeResultUseCase = FakeLoadHoleResultUseCase(
      initialValue: fakeTeamHoleResultViewData(),
    );
    final gameSummaryUseCase = FakeLoadGameSummaryUseCase();

    await tester.pumpWidget(
      buildTestApp(
        gameRepository: gameRepository,
        holeResultUseCase: holeResultUseCase,
        gameSummaryUseCase: gameSummaryUseCase,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Team Net'), findsOneWidget);
    expect(find.text('Team A'), findsOneWidget);
    expect(find.text('Team B'), findsOneWidget);

    await tester.tap(find.text('Detail'));
    await tester.pumpAndSettle();

    expect(find.text('Team Movements'), findsOneWidget);
    expect(find.text('Team B → Team A'), findsOneWidget);
  });
}
