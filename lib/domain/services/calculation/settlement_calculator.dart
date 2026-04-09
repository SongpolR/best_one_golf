import 'dart:math';

import '../../entities/game_calculation_result.dart';

class SettlementCalculator {
  const SettlementCalculator();

  GameCalculationResult aggregate({
    required List<HoleCalculationResult> holeResults,
  }) {
    final totalByPlayer = <String, int>{};

    for (final hole in holeResults) {
      for (final entry in hole.playerNet.entries) {
        totalByPlayer[entry.key] =
            (totalByPlayer[entry.key] ?? 0) + entry.value;
      }
    }

    // Derive settlements from exact net totals rather than MoneyMovement
    // records, which can lose precision due to integer division in team splits.
    final settlements = _settleDebts(totalByPlayer);

    return GameCalculationResult(
      holeResults: holeResults,
      totalByPlayer: totalByPlayer,
      settlements: settlements,
    );
  }

  /// Greedy debt-simplification: repeatedly match the largest debtor against
  /// the largest creditor until all balances are zero.
  List<SettlementEntry> _settleDebts(Map<String, int> totalByPlayer) {
    final debtors = totalByPlayer.entries
        .where((e) => e.value < 0)
        .map((e) => _Balance(id: e.key, amount: -e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final creditors = totalByPlayer.entries
        .where((e) => e.value > 0)
        .map((e) => _Balance(id: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final settlements = <SettlementEntry>[];
    var i = 0;
    var j = 0;

    while (i < debtors.length && j < creditors.length) {
      final payment = min(debtors[i].amount, creditors[j].amount);

      settlements.add(SettlementEntry(
        fromId: debtors[i].id,
        toId: creditors[j].id,
        amount: payment,
      ));

      debtors[i].amount -= payment;
      creditors[j].amount -= payment;

      if (debtors[i].amount == 0) i++;
      if (creditors[j].amount == 0) j++;
    }

    return settlements;
  }
}

class _Balance {
  final String id;
  int amount;

  _Balance({required this.id, required this.amount});
}
