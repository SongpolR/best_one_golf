class GameSummaryViewData {
  final Map<String, int> totalByPlayer;
  final List<GameSettlementViewData> settlements;

  const GameSummaryViewData({
    required this.totalByPlayer,
    required this.settlements,
  });
}

class GameSettlementViewData {
  final String fromId;
  final String toId;
  final int amount;

  const GameSettlementViewData({
    required this.fromId,
    required this.toId,
    required this.amount,
  });
}
