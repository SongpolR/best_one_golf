import '../../../core/enums/game_mode.dart';
import '../../entities/game_aggregate.dart';
import '../../entities/game_calculation_result.dart';
import 'individual_calculator.dart';
import 'settlement_calculator.dart';
import 'team_calculator.dart';

class GameCalculator {
  final IndividualCalculator individualCalculator;
  final TeamCalculator teamCalculator;
  final SettlementCalculator settlementCalculator;

  const GameCalculator({
    this.individualCalculator = const IndividualCalculator(),
    this.teamCalculator = const TeamCalculator(),
    this.settlementCalculator = const SettlementCalculator(),
  });

  GameCalculationResult calculate(GameAggregate aggregate) {
    final holeResults = aggregate.holeConfigs.map((holeConfig) {
      final holeScores = aggregate.holeScores
          .where((score) => score.holeNumber == holeConfig.holeNumber)
          .toList();

      if (aggregate.game.mode == GameMode.team) {
        return teamCalculator.compute(
          players: aggregate.players,
          teams: aggregate.teams,
          scores: holeScores,
          holeConfig: holeConfig,
          settings: aggregate.settings,
        );
      }

      return individualCalculator.compute(
        players: aggregate.players,
        scores: holeScores,
        holeConfig: holeConfig,
        settings: aggregate.settings,
      );
    }).toList();

    return settlementCalculator.aggregate(
      holeResults: holeResults,
    );
  }
}
