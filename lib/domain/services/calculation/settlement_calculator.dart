import '../../entities/game_calculation_result.dart';

class SettlementCalculator {
  const SettlementCalculator();

  GameCalculationResult aggregate({
    required List<HoleCalculationResult> holeResults,
  }) {
    final totalByPlayer = <String, int>{};
    final settlementMap = <String, int>{};

    for (final hole in holeResults) {
      for (final entry in hole.playerNet.entries) {
        totalByPlayer[entry.key] =
            (totalByPlayer[entry.key] ?? 0) + entry.value;
      }

      for (final movement in hole.movements) {
        final key = '${movement.fromId}->${movement.toId}';
        settlementMap[key] = (settlementMap[key] ?? 0) + movement.amount;
      }
    }

    final settlements = settlementMap.entries.map((entry) {
      final parts = entry.key.split('->');
      return SettlementEntry(
        fromId: parts[0],
        toId: parts[1],
        amount: entry.value,
      );
    }).toList();

    return GameCalculationResult(
      holeResults: holeResults,
      totalByPlayer: totalByPlayer,
      settlements: settlements,
    );
  }
}
