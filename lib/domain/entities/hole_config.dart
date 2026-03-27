class HoleConfig {
  final String id;
  final String gameId;
  final int holeNumber;
  final int par;
  final bool isTurbo;
  final bool isBirdieBonus;

  const HoleConfig({
    required this.id,
    required this.gameId,
    required this.holeNumber,
    required this.par,
    required this.isTurbo,
    required this.isBirdieBonus,
  });
}
