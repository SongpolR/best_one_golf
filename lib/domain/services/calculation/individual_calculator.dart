import '../../entities/game_calculation_result.dart';
import '../../entities/hole_config.dart';
import '../../entities/hole_score.dart';
import '../../entities/player.dart';
import '../../entities/game_rule_settings.dart';
import 'multiplier_calculator.dart';

class IndividualCalculator {
  final MultiplierCalculator multiplierCalculator;

  const IndividualCalculator({
    this.multiplierCalculator = const MultiplierCalculator(),
  });

  HoleCalculationResult compute({
    required List<Player> players,
    required List<HoleScore> scores,
    required HoleConfig holeConfig,
    required GameRuleSettings settings,
  }) {
    final scoreMap = <String, int?>{
      for (final score in scores) score.playerId: score.strokes,
    };

    final filledCount =
        players.where((player) => scoreMap[player.id] != null).length;

    if (filledCount < players.length) {
      return HoleCalculationResult.incomplete(
        holeNumber: holeConfig.holeNumber,
        isTurbo: holeConfig.isTurbo,
        isBirdieBonus: holeConfig.isBirdieBonus,
      );
    }

    final baseAmount = settings.bestOneAmount ?? 0;
    final movements = <MoneyMovement>[];
    final net = <String, int>{};

    for (var i = 0; i < players.length; i++) {
      for (var j = i + 1; j < players.length; j++) {
        final playerA = players[i];
        final playerB = players[j];

        final scoreA = scoreMap[playerA.id]!;
        final scoreB = scoreMap[playerB.id]!;

        if (scoreA == scoreB) {
          continue;
        }

        final winner = scoreA < scoreB ? playerA : playerB;
        final loser = scoreA < scoreB ? playerB : playerA;
        final decidingScore = scoreA < scoreB ? scoreA : scoreB;

        final amount = multiplierCalculator.apply(
          baseAmount: baseAmount,
          decidingScore: decidingScore,
          par: holeConfig.par,
          isTurbo: holeConfig.isTurbo,
          isBirdieBonus: holeConfig.isBirdieBonus,
        );

        movements.add(
          MoneyMovement(
            fromId: loser.id,
            toId: winner.id,
            amount: amount,
            holeNumber: holeConfig.holeNumber,
            rule: 'individual',
            note: 'gross',
          ),
        );

        net[winner.id] = (net[winner.id] ?? 0) + amount;
        net[loser.id] = (net[loser.id] ?? 0) - amount;
      }
    }

    return HoleCalculationResult(
      holeNumber: holeConfig.holeNumber,
      isComplete: true,
      movements: movements,
      playerNet: net,
      baseAmount: baseAmount,
      isTurbo: holeConfig.isTurbo,
      isBirdieBonus: holeConfig.isBirdieBonus,
    );
  }
}
