class Player {
  final String id;
  final String gameId;
  final String name;
  final int order;
  final String? teamId;

  const Player({
    required this.id,
    required this.gameId,
    required this.name,
    required this.order,
    required this.teamId,
  });
}
