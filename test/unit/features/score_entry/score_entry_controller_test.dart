import 'package:best_one_golf/app/app.dart';
import 'package:best_one_golf/core/enums/hole_state.dart';
import 'package:best_one_golf/domain/entities/game_aggregate.dart';
import 'package:best_one_golf/domain/entities/hole_score.dart';
import 'package:best_one_golf/features/score_entry/presentation/score_entry_controller.dart';
import '../../../fakes/fake_game_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScoreEntryController', () {
    test('getHoleState returns empty when no scores exist', () {
      final aggregate = fakeGameAggregate();

      final container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(
            FakeGameRepository(gameAggregate: aggregate),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(scoreEntryControllerProvider);

      final result = controller.getHoleState(
        aggregate: aggregate,
        holeNumber: 1,
      );

      expect(result, HoleState.empty);
    });

    test('getHoleState returns partial when some scores exist', () {
      final aggregate = _copyAggregateWithScores(
        fakeGameAggregate(),
        [
          const HoleScore(
            id: '1',
            gameId: 'game-1',
            holeNumber: 1,
            playerId: 'p1',
            strokes: 4,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(
            FakeGameRepository(gameAggregate: aggregate),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(scoreEntryControllerProvider);

      final result = controller.getHoleState(
        aggregate: aggregate,
        holeNumber: 1,
      );

      expect(result, HoleState.partial);
    });

    test('getHoleState returns complete when all player scores exist', () {
      final aggregate = _copyAggregateWithScores(
        fakeGameAggregate(),
        const [
          HoleScore(
            id: '1',
            gameId: 'game-1',
            holeNumber: 1,
            playerId: 'p1',
            strokes: 4,
          ),
          HoleScore(
            id: '2',
            gameId: 'game-1',
            holeNumber: 1,
            playerId: 'p2',
            strokes: 5,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(
            FakeGameRepository(gameAggregate: aggregate),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(scoreEntryControllerProvider);

      final result = controller.getHoleState(
        aggregate: aggregate,
        holeNumber: 1,
      );

      expect(result, HoleState.complete);
    });

    test('nextHole increases selected hole', () {
      final aggregate = fakeGameAggregate();

      final container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(
            FakeGameRepository(gameAggregate: aggregate),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(scoreEntryControllerProvider);

      controller.nextHole(aggregate);

      expect(container.read(selectedHoleProvider), 2);
    });

    test('previousHole decreases selected hole', () {
      final aggregate = fakeGameAggregate();

      final container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(
            FakeGameRepository(gameAggregate: aggregate),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(selectedHoleProvider.notifier).state = 3;

      final controller = container.read(scoreEntryControllerProvider);

      controller.previousHole();

      expect(container.read(selectedHoleProvider), 2);
    });

    test('jumpToHole changes selected hole directly', () {
      final aggregate = fakeGameAggregate();

      final container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(
            FakeGameRepository(gameAggregate: aggregate),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(scoreEntryControllerProvider);

      controller.jumpToHole(7);

      expect(container.read(selectedHoleProvider), 7);
    });
  });
}

GameAggregate _copyAggregateWithScores(
  GameAggregate aggregate,
  List<HoleScore> scores,
) {
  return GameAggregate(
    game: aggregate.game,
    settings: aggregate.settings,
    players: aggregate.players,
    teams: aggregate.teams,
    holeConfigs: aggregate.holeConfigs,
    holeScores: scores,
  );
}
