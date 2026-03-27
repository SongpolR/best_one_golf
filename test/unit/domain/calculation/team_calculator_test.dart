import 'package:best_one_golf/domain/entities/game_rule_settings.dart';
import 'package:best_one_golf/domain/entities/hole_config.dart';
import 'package:best_one_golf/domain/entities/hole_score.dart';
import 'package:best_one_golf/domain/entities/player.dart';
import 'package:best_one_golf/domain/entities/team.dart';
import 'package:best_one_golf/domain/services/calculation/team_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamCalculator', () {
    const teams2v2 = [
      Team(
        id: 't1',
        gameId: 'g1',
        name: 'Team A',
        order: 0,
      ),
      Team(
        id: 't2',
        gameId: 'g1',
        name: 'Team B',
        order: 1,
      ),
    ];

    const players2v2 = [
      Player(
        id: 'p1',
        gameId: 'g1',
        name: 'A1',
        order: 0,
        teamId: 't1',
      ),
      Player(
        id: 'p2',
        gameId: 'g1',
        name: 'A2',
        order: 1,
        teamId: 't1',
      ),
      Player(
        id: 'p3',
        gameId: 'g1',
        name: 'B1',
        order: 2,
        teamId: 't2',
      ),
      Player(
        id: 'p4',
        gameId: 'g1',
        name: 'B2',
        order: 3,
        teamId: 't2',
      ),
    ];

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

    const bestOneOnly = GameRuleSettings(
      gameId: 'g1',
      bestOneEnabled: true,
      bestTwoEnabled: false,
      sharedBetDefault: true,
      bestOneAmount: 20,
      bestTwoAmount: 20,
    );

    const bestTwoOnly = GameRuleSettings(
      gameId: 'g1',
      bestOneEnabled: false,
      bestTwoEnabled: true,
      sharedBetDefault: true,
      bestOneAmount: 20,
      bestTwoAmount: 20,
    );

    const bestOneAndTwo = GameRuleSettings(
      gameId: 'g1',
      bestOneEnabled: true,
      bestTwoEnabled: true,
      sharedBetDefault: true,
      bestOneAmount: 20,
      bestTwoAmount: 20,
    );

    const calculator = TeamCalculator();

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
        HoleScore(
          id: 's3',
          gameId: 'g1',
          holeNumber: 1,
          playerId: 'p3',
          strokes: 4,
        ),
      ];

      final result = calculator.compute(
        players: players2v2,
        teams: teams2v2,
        scores: scores,
        holeConfig: normalHole,
        settings: bestOneOnly,
      );

      expect(result.isComplete, false);
      expect(result.movements, isEmpty);
      expect(result.teamMovements, isEmpty);
    });

    test('calculates best one correctly for 2v2', () {
      const scores = [
        HoleScore(
            id: 's1', gameId: 'g1', holeNumber: 1, playerId: 'p1', strokes: 4),
        HoleScore(
            id: 's2', gameId: 'g1', holeNumber: 1, playerId: 'p2', strokes: 5),
        HoleScore(
            id: 's3', gameId: 'g1', holeNumber: 1, playerId: 'p3', strokes: 5),
        HoleScore(
            id: 's4', gameId: 'g1', holeNumber: 1, playerId: 'p4', strokes: 6),
      ];

      final result = calculator.compute(
        players: players2v2,
        teams: teams2v2,
        scores: scores,
        holeConfig: normalHole,
        settings: bestOneOnly,
      );

      expect(result.isComplete, true);
      expect(result.teamMovements.length, 1);

      final move = result.teamMovements.first;
      expect(move.fromTeamId, 't2');
      expect(move.toTeamId, 't1');
      expect(move.amount, 20);
      expect(move.rule, 'best_one');

      expect(result.teamNet['t1'], 20);
      expect(result.teamNet['t2'], -20);

      expect(result.playerNet['p1'], 10);
      expect(result.playerNet['p2'], 10);
      expect(result.playerNet['p3'], -10);
      expect(result.playerNet['p4'], -10);
    });

    test('calculates best two correctly for 2v2', () {
      const scores = [
        HoleScore(
            id: 's1', gameId: 'g1', holeNumber: 1, playerId: 'p1', strokes: 4),
        HoleScore(
            id: 's2', gameId: 'g1', holeNumber: 1, playerId: 'p2', strokes: 6),
        HoleScore(
            id: 's3', gameId: 'g1', holeNumber: 1, playerId: 'p3', strokes: 5),
        HoleScore(
            id: 's4', gameId: 'g1', holeNumber: 1, playerId: 'p4', strokes: 7),
      ];

      final result = calculator.compute(
        players: players2v2,
        teams: teams2v2,
        scores: scores,
        holeConfig: normalHole,
        settings: bestTwoOnly,
      );

      expect(result.teamMovements.length, 1);

      final move = result.teamMovements.first;
      expect(move.fromTeamId, 't2');
      expect(move.toTeamId, 't1');
      expect(move.amount, 20);
      expect(move.rule, 'best_two');

      expect(result.playerNet['p1'], 10);
      expect(result.playerNet['p2'], 10);
      expect(result.playerNet['p3'], -10);
      expect(result.playerNet['p4'], -10);
    });

    test('calculates best one and best two together', () {
      const scores = [
        HoleScore(
            id: 's1', gameId: 'g1', holeNumber: 1, playerId: 'p1', strokes: 4),
        HoleScore(
            id: 's2', gameId: 'g1', holeNumber: 1, playerId: 'p2', strokes: 6),
        HoleScore(
            id: 's3', gameId: 'g1', holeNumber: 1, playerId: 'p3', strokes: 5),
        HoleScore(
            id: 's4', gameId: 'g1', holeNumber: 1, playerId: 'p4', strokes: 7),
      ];

      final result = calculator.compute(
        players: players2v2,
        teams: teams2v2,
        scores: scores,
        holeConfig: normalHole,
        settings: bestOneAndTwo,
      );

      expect(result.teamMovements.length, 2);
      expect(result.teamNet['t1'], 40);
      expect(result.teamNet['t2'], -40);

      expect(result.playerNet['p1'], 20);
      expect(result.playerNet['p2'], 20);
      expect(result.playerNet['p3'], -20);
      expect(result.playerNet['p4'], -20);
    });

    test('ignores tied team comparison', () {
      const scores = [
        HoleScore(
            id: 's1', gameId: 'g1', holeNumber: 1, playerId: 'p1', strokes: 4),
        HoleScore(
            id: 's2', gameId: 'g1', holeNumber: 1, playerId: 'p2', strokes: 5),
        HoleScore(
            id: 's3', gameId: 'g1', holeNumber: 1, playerId: 'p3', strokes: 4),
        HoleScore(
            id: 's4', gameId: 'g1', holeNumber: 1, playerId: 'p4', strokes: 6),
      ];

      final result = calculator.compute(
        players: players2v2,
        teams: teams2v2,
        scores: scores,
        holeConfig: normalHole,
        settings: bestOneOnly,
      );

      expect(result.teamMovements, isEmpty);
      expect(result.playerNet, isEmpty);
      expect(result.teamNet, isEmpty);
    });

    test('applies turbo and birdie bonus to team calculation', () {
      const scores = [
        HoleScore(
            id: 's1', gameId: 'g1', holeNumber: 2, playerId: 'p1', strokes: 3),
        HoleScore(
            id: 's2', gameId: 'g1', holeNumber: 2, playerId: 'p2', strokes: 5),
        HoleScore(
            id: 's3', gameId: 'g1', holeNumber: 2, playerId: 'p3', strokes: 4),
        HoleScore(
            id: 's4', gameId: 'g1', holeNumber: 2, playerId: 'p4', strokes: 6),
      ];

      final result = calculator.compute(
        players: players2v2,
        teams: teams2v2,
        scores: scores,
        holeConfig: turboBirdieHole,
        settings: bestOneOnly,
      );

      expect(result.teamMovements.length, 1);
      expect(result.teamMovements.first.amount, 80);

      expect(result.teamNet['t1'], 80);
      expect(result.teamNet['t2'], -80);

      expect(result.playerNet['p1'], 40);
      expect(result.playerNet['p2'], 40);
      expect(result.playerNet['p3'], -40);
      expect(result.playerNet['p4'], -40);
    });

    test('compares every team pair in 2v2v2', () {
      const teams = [
        Team(id: 't1', gameId: 'g1', name: 'Team A', order: 0),
        Team(id: 't2', gameId: 'g1', name: 'Team B', order: 1),
        Team(id: 't3', gameId: 'g1', name: 'Team C', order: 2),
      ];

      const players = [
        Player(id: 'p1', gameId: 'g1', name: 'A1', order: 0, teamId: 't1'),
        Player(id: 'p2', gameId: 'g1', name: 'A2', order: 1, teamId: 't1'),
        Player(id: 'p3', gameId: 'g1', name: 'B1', order: 2, teamId: 't2'),
        Player(id: 'p4', gameId: 'g1', name: 'B2', order: 3, teamId: 't2'),
        Player(id: 'p5', gameId: 'g1', name: 'C1', order: 4, teamId: 't3'),
        Player(id: 'p6', gameId: 'g1', name: 'C2', order: 5, teamId: 't3'),
      ];

      const scores = [
        HoleScore(
            id: 's1', gameId: 'g1', holeNumber: 1, playerId: 'p1', strokes: 4),
        HoleScore(
            id: 's2', gameId: 'g1', holeNumber: 1, playerId: 'p2', strokes: 5),
        HoleScore(
            id: 's3', gameId: 'g1', holeNumber: 1, playerId: 'p3', strokes: 5),
        HoleScore(
            id: 's4', gameId: 'g1', holeNumber: 1, playerId: 'p4', strokes: 6),
        HoleScore(
            id: 's5', gameId: 'g1', holeNumber: 1, playerId: 'p5', strokes: 6),
        HoleScore(
            id: 's6', gameId: 'g1', holeNumber: 1, playerId: 'p6', strokes: 7),
      ];

      final result = calculator.compute(
        players: players,
        teams: teams,
        scores: scores,
        holeConfig: normalHole,
        settings: bestOneOnly,
      );

      expect(result.teamMovements.length, 3);

      expect(result.teamNet['t1'], 40);
      expect(result.teamNet['t2'], 0);
      expect(result.teamNet['t3'], -40);
    });
  });
}
