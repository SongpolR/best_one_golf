class MoneyMovement {
  final String fromId;
  final String toId;
  final int amount;
  final int holeNumber;
  final String rule;
  final String note;

  const MoneyMovement({
    required this.fromId,
    required this.toId,
    required this.amount,
    required this.holeNumber,
    required this.rule,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromId': fromId,
      'toId': toId,
      'amount': amount,
      'holeNumber': holeNumber,
      'rule': rule,
      'note': note,
    };
  }
}

class TeamMovement {
  final String fromTeamId;
  final String toTeamId;
  final int amount;
  final int holeNumber;
  final String rule;
  final String note;

  const TeamMovement({
    required this.fromTeamId,
    required this.toTeamId,
    required this.amount,
    required this.holeNumber,
    required this.rule,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromTeamId': fromTeamId,
      'toTeamId': toTeamId,
      'amount': amount,
      'holeNumber': holeNumber,
      'rule': rule,
      'note': note,
    };
  }
}

class HoleCalculationResult {
  final int holeNumber;
  final bool isComplete;
  final List<MoneyMovement> movements;
  final List<TeamMovement> teamMovements;
  final Map<String, int> playerNet;
  final Map<String, int> teamNet;
  final int? baseAmount;
  final bool isTurbo;
  final bool isBirdieBonus;

  const HoleCalculationResult({
    required this.holeNumber,
    required this.isComplete,
    required this.movements,
    required this.teamMovements,
    required this.playerNet,
    required this.teamNet,
    required this.baseAmount,
    required this.isTurbo,
    required this.isBirdieBonus,
  });

  factory HoleCalculationResult.incomplete({
    required int holeNumber,
    required bool isTurbo,
    required bool isBirdieBonus,
  }) {
    return HoleCalculationResult(
      holeNumber: holeNumber,
      isComplete: false,
      movements: const [],
      teamMovements: const [],
      playerNet: const {},
      teamNet: const {},
      baseAmount: null,
      isTurbo: isTurbo,
      isBirdieBonus: isBirdieBonus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'holeNumber': holeNumber,
      'isComplete': isComplete,
      'movements': movements.map((m) => m.toJson()).toList(),
      'teamMovements': teamMovements.map((m) => m.toJson()).toList(),
      'playerNet': playerNet,
      'teamNet': teamNet,
      'baseAmount': baseAmount,
      'isTurbo': isTurbo,
      'isBirdieBonus': isBirdieBonus,
    };
  }
}

class SettlementEntry {
  final String fromId;
  final String toId;
  final int amount;

  const SettlementEntry({
    required this.fromId,
    required this.toId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromId': fromId,
      'toId': toId,
      'amount': amount,
    };
  }
}

class GameCalculationResult {
  final List<HoleCalculationResult> holeResults;
  final Map<String, int> totalByPlayer;
  final List<SettlementEntry> settlements;

  const GameCalculationResult({
    required this.holeResults,
    required this.totalByPlayer,
    required this.settlements,
  });

  Map<String, dynamic> toJson() {
    return {
      'holeResults': holeResults.map((h) => h.toJson()).toList(),
      'totalByPlayer': totalByPlayer,
      'settlements': settlements.map((s) => s.toJson()).toList(),
    };
  }
}
