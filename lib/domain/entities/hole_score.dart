class HoleScore {
  final String id;
  final String gameId;
  final int holeNumber;
  final String playerId;
  final int? strokes;

  const HoleScore({
    required this.id,
    required this.gameId,
    required this.holeNumber,
    required this.playerId,
    required this.strokes,
  });
}
