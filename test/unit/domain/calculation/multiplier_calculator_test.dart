import 'package:best_one_golf/domain/services/calculation/multiplier_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MultiplierCalculator', () {
    const calculator = MultiplierCalculator();

    test('returns base amount when no turbo and no birdie bonus', () {
      final result = calculator.apply(
        baseAmount: 20,
        decidingScore: 4,
        par: 4,
        isTurbo: false,
        isBirdieBonus: false,
      );

      expect(result, 20);
    });

    test('applies turbo x2', () {
      final result = calculator.apply(
        baseAmount: 20,
        decidingScore: 4,
        par: 4,
        isTurbo: true,
        isBirdieBonus: false,
      );

      expect(result, 40);
    });

    test('applies birdie bonus x2 when score is lower than par', () {
      final result = calculator.apply(
        baseAmount: 20,
        decidingScore: 3,
        par: 4,
        isTurbo: false,
        isBirdieBonus: true,
      );

      expect(result, 40);
    });

    test('applies both turbo and birdie bonus', () {
      final result = calculator.apply(
        baseAmount: 20,
        decidingScore: 3,
        par: 4,
        isTurbo: true,
        isBirdieBonus: true,
      );

      expect(result, 80);
    });

    test('does not apply birdie bonus when score equals par', () {
      final result = calculator.apply(
        baseAmount: 20,
        decidingScore: 4,
        par: 4,
        isTurbo: false,
        isBirdieBonus: true,
      );

      expect(result, 20);
    });
  });
}
