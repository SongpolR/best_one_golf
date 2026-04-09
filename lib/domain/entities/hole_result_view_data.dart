class HoleResultViewData {
  final int holeNumber;
  final bool isComplete;
  final bool isTurbo;
  final bool isBirdieBonus;
  final int? baseAmount;
  final List<HoleMovementViewData> playerMovements;
  final List<HoleTeamMovementViewData> teamMovements;
  final Map<String, int> playerNet;
  final Map<String, int> teamNet;

  const HoleResultViewData({
    required this.holeNumber,
    required this.isComplete,
    required this.isTurbo,
    required this.isBirdieBonus,
    required this.baseAmount,
    required this.playerMovements,
    required this.teamMovements,
    required this.playerNet,
    required this.teamNet,
  });
}

class HoleMovementViewData {
  final String fromId;
  final String toId;
  final int amount;
  final String rule;
  final String note;

  const HoleMovementViewData({
    required this.fromId,
    required this.toId,
    required this.amount,
    required this.rule,
    required this.note,
  });
}

class HoleTeamMovementViewData {
  final String fromTeamId;
  final String toTeamId;
  final int amount;
  final String rule;
  final String note;

  const HoleTeamMovementViewData({
    required this.fromTeamId,
    required this.toTeamId,
    required this.amount,
    required this.rule,
    required this.note,
  });
}
