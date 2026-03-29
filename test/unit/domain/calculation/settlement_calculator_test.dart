import 'package:best_one_golf/domain/entities/game_calculation_result.dart';
import 'package:best_one_golf/domain/services/calculation/settlement_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettlementCalculator', () {
    const calculator = SettlementCalculator();

    test('aggregates totals and settlements across holes', () {
      const hole1 = HoleCalculationResult(
        holeNumber: 1,
        isComplete: true,
        movements: [
          MoneyMovement(
            fromId: 'p2',
            toId: 'p1',
            amount: 20,
            holeNumber: 1,
            rule: 'individual',
            note: 'gross',
          ),
        ],
        teamMovements: [],
        playerNet: {
          'p1': 20,
          'p2': -20,
        },
        teamNet: {},
        baseAmount: 20,
        isTurbo: false,
        isBirdieBonus: false,
      );

      const hole2 = HoleCalculationResult(
        holeNumber: 2,
        isComplete: true,
        movements: [
          MoneyMovement(
            fromId: 'p2',
            toId: 'p1',
            amount: 40,
            holeNumber: 2,
            rule: 'individual',
            note: 'gross',
          ),
          MoneyMovement(
            fromId: 'p3',
            toId: 'p1',
            amount: 40,
            holeNumber: 2,
            rule: 'individual',
            note: 'gross',
          ),
        ],
        teamMovements: [],
        playerNet: {
          'p1': 80,
          'p2': -40,
          'p3': -40,
        },
        teamNet: {},
        baseAmount: 20,
        isTurbo: true,
        isBirdieBonus: false,
      );

      final result = calculator.aggregate(
        holeResults: const [hole1, hole2],
      );

      expect(result.totalByPlayer['p1'], 100);
      expect(result.totalByPlayer['p2'], -60);
      expect(result.totalByPlayer['p3'], -40);

      expect(result.settlements.length, 2);

      final p2ToP1 = result.settlements.firstWhere(
        (entry) => entry.fromId == 'p2' && entry.toId == 'p1',
      );
      expect(p2ToP1.amount, 60);

      final p3ToP1 = result.settlements.firstWhere(
        (entry) => entry.fromId == 'p3' && entry.toId == 'p1',
      );
      expect(p3ToP1.amount, 40);
    });
  });
}
