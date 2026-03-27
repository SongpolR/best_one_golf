import '../../core/enums/game_mode.dart';

class CreateGamePlayerInput {
  final String name;
  final int order;
  final int? teamIndex;

  const CreateGamePlayerInput({
    required this.name,
    required this.order,
    required this.teamIndex,
  });
}

class CreateGameTeamInput {
  final String name;
  final int order;

  const CreateGameTeamInput({
    required this.name,
    required this.order,
  });
}

class CreateGameHoleInput {
  final int holeNumber;
  final int par;
  final bool isTurbo;
  final bool isBirdieBonus;

  const CreateGameHoleInput({
    required this.holeNumber,
    required this.par,
    required this.isTurbo,
    required this.isBirdieBonus,
  });
}

class CreateGameInput {
  final String title;
  final GameMode mode;
  final List<CreateGamePlayerInput> players;
  final List<CreateGameTeamInput> teams;
  final bool bestOneEnabled;
  final bool bestTwoEnabled;
  final bool sharedBetDefault;
  final int? bestOneAmount;
  final int? bestTwoAmount;
  final List<CreateGameHoleInput> holes;

  const CreateGameInput({
    required this.title,
    required this.mode,
    required this.players,
    required this.teams,
    required this.bestOneEnabled,
    required this.bestTwoEnabled,
    required this.sharedBetDefault,
    required this.bestOneAmount,
    required this.bestTwoAmount,
    required this.holes,
  });
}
