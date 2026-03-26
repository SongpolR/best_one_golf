class GameRuleSettings {
  final String gameId;
  final bool bestOneEnabled;
  final bool bestTwoEnabled;
  final bool sharedBetDefault;
  final int? bestOneAmount;
  final int? bestTwoAmount;

  const GameRuleSettings({
    required this.gameId,
    required this.bestOneEnabled,
    required this.bestTwoEnabled,
    required this.sharedBetDefault,
    required this.bestOneAmount,
    required this.bestTwoAmount,
  });
}
