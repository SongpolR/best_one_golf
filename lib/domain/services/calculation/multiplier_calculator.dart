class MultiplierCalculator {
  const MultiplierCalculator();

  int apply({
    required int baseAmount,
    required int decidingScore,
    required int par,
    required bool isTurbo,
    required bool isBirdieBonus,
  }) {
    var amount = baseAmount;

    if (isTurbo) {
      amount *= 2;
    }

    if (isBirdieBonus && decidingScore < par) {
      amount *= 2;
    }

    return amount;
  }
}
