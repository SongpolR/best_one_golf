import 'package:best_one_golf/domain/entities/game_rule_settings.dart';
import 'package:best_one_golf/domain/entities/hole_config.dart';
import 'package:best_one_golf/domain/entities/hole_score.dart';
import 'package:best_one_golf/domain/entities/player.dart';
import 'package:best_one_golf/domain/services/calculation/individual_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IndividualCalculator', () {
    const players = [
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
      Player(
        id: 'p3',
        gameId: 'g1',
        name: 'Charlie',
        order: 2,
        teamId: null,
      ),
    ];

    const settings = GameRuleSettings(
      gameId: 'g1',
      bestOneEnabled: true,
      bestTwoEnabled: false,
      sharedBetDefault: true,
      bestOneAmount: 20,
      bestTwoAmount: 20,
    );

    const normalHole = HoleConfig(
      id: 'h1',
      gameId: 'g1',
      holeNumber: 1,
      par: 4,
      isTurbo: false,
      isBirdieBonus: false,
    );

    const turboBirdieHole = HoleConfig(
      id: 'h2',
      gameId: 'g1',
      holeNumber: 2,
      par: 4,
      isTurbo: true,
      isBirdieBonus: true,
    );

    const calculator = IndividualCalculator();

    test('returns incomplete when not all player scores are present', () {
      const scores = [
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
      ];

      final result = calculator.compute(
        players: players,
        scores: scores,
        holeConfig: normalHole,
        settings: settings,
      );

      expect(result.isComplete, false);
      expect(result.movements, isEmpty);
      expect(result.playerNet, isEmpty);
    });

    test('calculates pairwise movements correctly for complete hole', () {
      const scores = [
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
          holeNumber: 1,
          playerId: 'p3',
          strokes: 6,
        ),
      ];

      final result = calculator.compute(
        players: players,
        scores: scores,
        holeConfig: normalHole,
        settings: settings,
      );

      expect(result.isComplete, true);
      expect(result.movements.length, 3);

      expect(result.playerNet['p1'], 40);
      expect(result.playerNet['p2'], 0);
      expect(result.playerNet['p3'], -40);
    });

    test('ignores tied pairings', () {
      const scores = [
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
          strokes: 4,
        ),
        HoleScore(
          id: 's3',
          gameId: 'g1',
          holeNumber: 1,
          playerId: 'p3',
          strokes: 5,
        ),
      ];

      final result = calculator.compute(
        players: players,
        scores: scores,
        holeConfig: normalHole,
        settings: settings,
      );

      expect(result.movements.length, 2);
      expect(result.playerNet['p1'], 20);
      expect(result.playerNet['p2'], 20);
      expect(result.playerNet['p3'], -40);
    });

    test('applies turbo and birdie bonus to movement amount', () {
      const scores = [
        HoleScore(
          id: 's1',
          gameId: 'g1',
          holeNumber: 2,
          playerId: 'p1',
          strokes: 3,
        ),
        HoleScore(
          id: 's2',
          gameId: 'g1',
          holeNumber: 2,
          playerId: 'p2',
          strokes: 5,
        ),
        HoleScore(
          id: 's3',
          gameId: 'g1',
          holeNumber: 2,
          playerId: 'p3',
          strokes: 6,
        ),
      ];

      final result = calculator.compute(
        players: players,
        scores: scores,
        holeConfig: turboBirdieHole,
        settings: settings,
      );

      expect(result.movements.length, 3);
      expect(result.playerNet['p1'], 160);
      expect(result.playerNet['p2'], -40);
      expect(result.playerNet['p3'], -120);
    });
  });
}
