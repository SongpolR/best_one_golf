import 'package:best_one_golf/domain/entities/game.dart';
import 'package:best_one_golf/domain/entities/game_aggregate.dart';
import 'package:best_one_golf/domain/entities/game_rule_settings.dart';
import 'package:best_one_golf/domain/entities/hole_config.dart';
import 'package:best_one_golf/domain/entities/hole_score.dart';
import 'package:best_one_golf/domain/entities/player.dart';
import 'package:best_one_golf/domain/services/calculation/game_calculator.dart';
import 'package:best_one_golf/core/enums/game_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameCalculator', () {
    const calculator = GameCalculator();

    test('calculates all holes and aggregates player totals', () {
      final aggregate = GameAggregate(
        game: Game(
          id: 'g1',
          title: 'Saturday Match',
          mode: GameMode.individual,
          status: 'ongoing',
          totalHoles: 2,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
        settings: const GameRuleSettings(
          gameId: 'g1',
          bestOneEnabled: true,
          bestTwoEnabled: false,
          sharedBetDefault: true,
          bestOneAmount: 20,
          bestTwoAmount: 20,
        ),
        players: const [
          Player(
            id: 'p1',
            gameId: 'g1',
            name: 'Alice',
            order: 0,
            teamId: null,
          ),
          Player(
            id: 'p2',
            gameId: 'g1',
            name: 'Bob',
            order: 1,
            teamId: null,
          ),
        ],
        teams: const [],
        holeConfigs: const [
          HoleConfig(
            id: 'h1',
            gameId: 'g1',
            holeNumber: 1,
            par: 4,
            isTurbo: false,
            isBirdieBonus: false,
          ),
          HoleConfig(
            id: 'h2',
            gameId: 'g1',
            holeNumber: 2,
            par: 4,
            isTurbo: true,
            isBirdieBonus: true,
          ),
        ],
        holeScores: const [
          HoleScore(
            id: 's1',
            gameId: 'g1',
            holeNumber: 1,
            playerId: 'p1',
            strokes: 4,
          ),
          HoleScore(
            id: 's2',
            gameId: 'g1',
            holeNumber: 1,
            playerId: 'p2',
            strokes: 5,
          ),
          HoleScore(
            id: 's3',
            gameId: 'g1',
            holeNumber: 2,
            playerId: 'p1',
            strokes: 3,
          ),
          HoleScore(
            id: 's4',
            gameId: 'g1',
            holeNumber: 2,
            playerId: 'p2',
            strokes: 5,
          ),
        ],
      );

      final result = calculator.calculate(aggregate);

      expect(result.holeResults.length, 2);
      expect(result.totalByPlayer['p1'], 100);
      expect(result.totalByPlayer['p2'], -100);
      expect(result.settlements.length, 1);
      expect(result.settlements.first.amount, 100);
    });

    test('marks incomplete holes correctly', () {
      final aggregate = GameAggregate(
        game: Game(
          id: 'g1',
          title: 'Saturday Match',
          mode: GameMode.individual,
          status: 'ongoing',
          totalHoles: 1,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
        settings: const GameRuleSettings(
          gameId: 'g1',
          bestOneEnabled: true,
          bestTwoEnabled: false,
          sharedBetDefault: true,
          bestOneAmount: 20,
          bestTwoAmount: 20,
        ),
        players: const [
          Player(
            id: 'p1',
            gameId: 'g1',
            name: 'Alice',
            order: 0,
            teamId: null,
          ),
          Player(
            id: 'p2',
            gameId: 'g1',
            name: 'Bob',
            order: 1,
            teamId: null,
          ),
        ],
        teams: const [],
        holeConfigs: const [
          HoleConfig(
            id: 'h1',
            gameId: 'g1',
            holeNumber: 1,
            par: 4,
            isTurbo: false,
            isBirdieBonus: false,
          ),
        ],
        holeScores: const [
          HoleScore(
            id: 's1',
            gameId: 'g1',
            holeNumber: 1,
            playerId: 'p1',
            strokes: 4,
          ),
        ],
      );

      final result = calculator.calculate(aggregate);

      expect(result.holeResults.first.isComplete, false);
      expect(result.totalByPlayer, isEmpty);
      expect(result.settlements, isEmpty);
    });
  });
}
