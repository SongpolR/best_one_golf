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

    // 2v2: each losing player pays baseAmount → team total = baseAmount × 2 losers
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
      // Each of the 2 losers pays 20 → team total = 40
      expect(move.amount, 40);
      expect(move.rule, 'best_one');

      expect(result.teamNet['t1'], 40);
      expect(result.teamNet['t2'], -40);

      // Each loser pays 20; each winner gains 40/2 = 20
      expect(result.playerNet['p1'], 20);
      expect(result.playerNet['p2'], 20);
      expect(result.playerNet['p3'], -20);
      expect(result.playerNet['p4'], -20);
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
      expect(move.amount, 40);
      expect(move.rule, 'best_two');

      expect(result.playerNet['p1'], 20);
      expect(result.playerNet['p2'], 20);
      expect(result.playerNet['p3'], -20);
      expect(result.playerNet['p4'], -20);
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
      // Best One: 40 + Best Two: 40 = 80 total
      expect(result.teamNet['t1'], 80);
      expect(result.teamNet['t2'], -80);

      expect(result.playerNet['p1'], 40);
      expect(result.playerNet['p2'], 40);
      expect(result.playerNet['p3'], -40);
      expect(result.playerNet['p4'], -40);
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

    // Turbo + birdie: perLoserAmount = 20×2×2 = 80, each of 2 losers pays 80
    // → teamAmount = 160, each winner gains 80
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
      // perLoserAmount = 80; 2 losers → teamAmount = 160
      expect(result.teamMovements.first.amount, 160);

      expect(result.teamNet['t1'], 160);
      expect(result.teamNet['t2'], -160);

      // Each loser pays 80; each winner gains 160/2 = 80
      expect(result.playerNet['p1'], 80);
      expect(result.playerNet['p2'], 80);
      expect(result.playerNet['p3'], -80);
      expect(result.playerNet['p4'], -80);
    });

    // 3-team 2v2v2: each team pair comparison uses perLoser × 2 losers
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

      // t1 beats t2 (40) + t1 beats t3 (40) = 80
      // t2 loses to t1 (−40) + t2 beats t3 (+40) = 0
      // t3 loses to t1 (−40) + t3 loses to t2 (−40) = −80
      expect(result.teamNet['t1'], 80);
      expect(result.teamNet['t2'], 0);
      expect(result.teamNet['t3'], -80);
    });

    // Exact 3v3 scenario from business requirements:
    // Hole 1 par 4: X=[4,5,5] Y=[4,6,6]
    // Best One: X=4 vs Y=4 → tie, no movement
    // Best Two: X=5 vs Y=6 → X wins, each Y player pays 20 → total 60
    test('3v3 scenario: best one ties, best two wins for team X', () {
      const teams = [
        Team(id: 'x', gameId: 'g1', name: 'Team X', order: 0),
        Team(id: 'y', gameId: 'g1', name: 'Team Y', order: 1),
      ];

      const players = [
        Player(id: 'a', gameId: 'g1', name: 'A', order: 0, teamId: 'x'),
        Player(id: 'b', gameId: 'g1', name: 'B', order: 1, teamId: 'x'),
        Player(id: 'c', gameId: 'g1', name: 'C', order: 2, teamId: 'x'),
        Player(id: 'd', gameId: 'g1', name: 'D', order: 3, teamId: 'y'),
        Player(id: 'e', gameId: 'g1', name: 'E', order: 4, teamId: 'y'),
        Player(id: 'f', gameId: 'g1', name: 'F', order: 5, teamId: 'y'),
      ];

      const scores = [
        HoleScore(id: 's1', gameId: 'g1', holeNumber: 1, playerId: 'a', strokes: 4),
        HoleScore(id: 's2', gameId: 'g1', holeNumber: 1, playerId: 'b', strokes: 5),
        HoleScore(id: 's3', gameId: 'g1', holeNumber: 1, playerId: 'c', strokes: 5),
        HoleScore(id: 's4', gameId: 'g1', holeNumber: 1, playerId: 'd', strokes: 6),
        HoleScore(id: 's5', gameId: 'g1', holeNumber: 1, playerId: 'e', strokes: 4),
        HoleScore(id: 's6', gameId: 'g1', holeNumber: 1, playerId: 'f', strokes: 6),
      ];

      const hole1 = HoleConfig(
        id: 'h1', gameId: 'g1', holeNumber: 1, par: 4,
        isTurbo: false, isBirdieBonus: false,
      );

      final result = calculator.compute(
        players: players,
        teams: teams,
        scores: scores,
        holeConfig: hole1,
        settings: bestOneAndTwo,
      );

      // Best One: X best=4, Y best=4 → tie, no movement
      // Best Two: X second=5, Y second=6 → X wins
      expect(result.teamMovements.length, 1);
      expect(result.teamMovements.first.rule, 'best_two');
      expect(result.teamMovements.first.fromTeamId, 'y');
      expect(result.teamMovements.first.toTeamId, 'x');
      // 3 losers × 20 = 60
      expect(result.teamMovements.first.amount, 60);

      expect(result.teamNet['x'], 60);
      expect(result.teamNet['y'], -60);

      // Each X player gains 60/3 = 20
      expect(result.playerNet['a'], 20);
      expect(result.playerNet['b'], 20);
      expect(result.playerNet['c'], 20);
      // Each Y player pays 20
      expect(result.playerNet['d'], -20);
      expect(result.playerNet['e'], -20);
      expect(result.playerNet['f'], -20);

      // Equal teams → 1-to-1 match by player order: d→a, e→b, f→c
      expect(result.movements.length, 3);
      expect(result.movements.every((m) => m.note == 'team_match'), true);
      expect(result.movements.every((m) => m.amount == 20), true);
      final pairs = {for (final m in result.movements) m.fromId: m.toId};
      expect(pairs['d'], 'a'); // d(order 3) → a(order 0)
      expect(pairs['e'], 'b'); // e(order 4) → b(order 1)
      expect(pairs['f'], 'c'); // f(order 5) → c(order 2)
    });

    // Hole 9 par 3 turbo+birdie: X=[3,3,5] Y=[2,2,7]
    // Best One: Y=2 wins (birdie vs par 3) → perLoser=20×2×2=80, 3 losers → 240
    // Best Two: Y=2 wins (birdie) → another 240
    // Each X player pays 80+80=160 total
    test('3v3 scenario hole 9: turbo+birdie best one and two both won by team Y', () {
      const teams = [
        Team(id: 'x', gameId: 'g1', name: 'Team X', order: 0),
        Team(id: 'y', gameId: 'g1', name: 'Team Y', order: 1),
      ];

      const players = [
        Player(id: 'a', gameId: 'g1', name: 'A', order: 0, teamId: 'x'),
        Player(id: 'b', gameId: 'g1', name: 'B', order: 1, teamId: 'x'),
        Player(id: 'c', gameId: 'g1', name: 'C', order: 2, teamId: 'x'),
        Player(id: 'd', gameId: 'g1', name: 'D', order: 3, teamId: 'y'),
        Player(id: 'e', gameId: 'g1', name: 'E', order: 4, teamId: 'y'),
        Player(id: 'f', gameId: 'g1', name: 'F', order: 5, teamId: 'y'),
      ];

      const scores = [
        HoleScore(id: 's1', gameId: 'g1', holeNumber: 9, playerId: 'a', strokes: 3),
        HoleScore(id: 's2', gameId: 'g1', holeNumber: 9, playerId: 'b', strokes: 3),
        HoleScore(id: 's3', gameId: 'g1', holeNumber: 9, playerId: 'c', strokes: 5),
        HoleScore(id: 's4', gameId: 'g1', holeNumber: 9, playerId: 'd', strokes: 2),
        HoleScore(id: 's5', gameId: 'g1', holeNumber: 9, playerId: 'e', strokes: 2),
        HoleScore(id: 's6', gameId: 'g1', holeNumber: 9, playerId: 'f', strokes: 7),
      ];

      const hole9 = HoleConfig(
        id: 'h9', gameId: 'g1', holeNumber: 9, par: 3,
        isTurbo: true, isBirdieBonus: true,
      );

      final result = calculator.compute(
        players: players,
        teams: teams,
        scores: scores,
        holeConfig: hole9,
        settings: bestOneAndTwo,
      );

      // Y best=2 < X best=3, deciding score=2 < par=3 → birdie+turbo → perLoser=80
      // Y second=2 < X second=3, same multipliers → perLoser=80
      expect(result.teamMovements.length, 2);

      final bestOneMove = result.teamMovements.firstWhere((m) => m.rule == 'best_one');
      expect(bestOneMove.fromTeamId, 'x');
      expect(bestOneMove.toTeamId, 'y');
      expect(bestOneMove.amount, 240); // 80 × 3

      final bestTwoMove = result.teamMovements.firstWhere((m) => m.rule == 'best_two');
      expect(bestTwoMove.fromTeamId, 'x');
      expect(bestTwoMove.toTeamId, 'y');
      expect(bestTwoMove.amount, 240); // 80 × 3

      expect(result.teamNet['y'], 480);
      expect(result.teamNet['x'], -480);

      // Each X player pays 80 (best one) + 80 (best two) = 160
      expect(result.playerNet['a'], -160);
      expect(result.playerNet['b'], -160);
      expect(result.playerNet['c'], -160);
      // Each Y player gains 240/3 + 240/3 = 160
      expect(result.playerNet['d'], 160);
      expect(result.playerNet['e'], 160);
      expect(result.playerNet['f'], 160);

      // Equal teams → 1-to-1 match per rule: a→d, b→e, c→f, each at 80
      // 2 rules × 3 losers = 6 movements total
      expect(result.movements.length, 6);
      expect(result.movements.every((m) => m.note == 'team_match'), true);
      expect(result.movements.every((m) => m.amount == 80), true);
      // Both best_one and best_two produce same pairs
      final bestOnePairs = {
        for (final m in result.movements.where((m) => m.rule == 'best_one'))
          m.fromId: m.toId,
      };
      expect(bestOnePairs['a'], 'd');
      expect(bestOnePairs['b'], 'e');
      expect(bestOnePairs['c'], 'f');
    });
  });
}
