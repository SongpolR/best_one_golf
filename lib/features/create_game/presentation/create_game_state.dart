import '../../../core/enums/game_mode.dart';

class PlayerDraft {
  final String name;
  final int order;
  final int? teamIndex;

  const PlayerDraft({
    required this.name,
    required this.order,
    required this.teamIndex,
  });

  PlayerDraft copyWith({
    String? name,
    int? order,
    int? teamIndex,
  }) {
    return PlayerDraft(
      name: name ?? this.name,
      order: order ?? this.order,
      teamIndex: teamIndex ?? this.teamIndex,
    );
  }
}

class TeamDraft {
  final String name;
  final int order;

  const TeamDraft({
    required this.name,
    required this.order,
  });

  TeamDraft copyWith({
    String? name,
    int? order,
  }) {
    return TeamDraft(
      name: name ?? this.name,
      order: order ?? this.order,
    );
  }
}

class HoleConfigDraft {
  final int holeNumber;
  final int par;
  final bool isTurbo;
  final bool isBirdieBonus;

  const HoleConfigDraft({
    required this.holeNumber,
    required this.par,
    required this.isTurbo,
    required this.isBirdieBonus,
  });

  HoleConfigDraft copyWith({
    int? par,
    bool? isTurbo,
    bool? isBirdieBonus,
  }) {
    return HoleConfigDraft(
      holeNumber: holeNumber,
      par: par ?? this.par,
      isTurbo: isTurbo ?? this.isTurbo,
      isBirdieBonus: isBirdieBonus ?? this.isBirdieBonus,
    );
  }
}

class CreateGameState {
  final String title;
  final GameMode mode;
  final List<PlayerDraft> players;
  final List<TeamDraft> teams;
  final bool bestOneEnabled;
  final bool bestTwoEnabled;
  final bool sharedBetDefault;
  final int? bestOneAmount;
  final int? bestTwoAmount;
  final List<HoleConfigDraft> holes;
  final bool isSubmitting;
  final String? errorMessage;

  const CreateGameState({
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
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory CreateGameState.initial() {
    return CreateGameState(
      title: '',
      mode: GameMode.individual,
      players: const [
        PlayerDraft(name: '', order: 0, teamIndex: null),
        PlayerDraft(name: '', order: 1, teamIndex: null),
      ],
      teams: const [
        TeamDraft(name: 'Team A', order: 0),
        TeamDraft(name: 'Team B', order: 1),
      ],
      bestOneEnabled: true,
      bestTwoEnabled: false,
      sharedBetDefault: true,
      bestOneAmount: 20,
      bestTwoAmount: 20,
      holes: List.generate(
        18,
        (index) => HoleConfigDraft(
          holeNumber: index + 1,
          par: 4,
          isTurbo: false,
          isBirdieBonus: false,
        ),
      ),
      isSubmitting: false,
      errorMessage: null,
    );
  }

  CreateGameState copyWith({
    String? title,
    GameMode? mode,
    List<PlayerDraft>? players,
    List<TeamDraft>? teams,
    bool? bestOneEnabled,
    bool? bestTwoEnabled,
    bool? sharedBetDefault,
    int? bestOneAmount,
    int? bestTwoAmount,
    List<HoleConfigDraft>? holes,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CreateGameState(
      title: title ?? this.title,
      mode: mode ?? this.mode,
      players: players ?? this.players,
      teams: teams ?? this.teams,
      bestOneEnabled: bestOneEnabled ?? this.bestOneEnabled,
      bestTwoEnabled: bestTwoEnabled ?? this.bestTwoEnabled,
      sharedBetDefault: sharedBetDefault ?? this.sharedBetDefault,
      bestOneAmount: bestOneAmount ?? this.bestOneAmount,
      bestTwoAmount: bestTwoAmount ?? this.bestTwoAmount,
      holes: holes ?? this.holes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}
