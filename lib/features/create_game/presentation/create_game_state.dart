import '../../../core/enums/game_mode.dart';
import '../../../domain/entities/game_aggregate.dart';

const Object _unset = Object();

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
    Object? teamIndex = _unset,
  }) {
    return PlayerDraft(
      name: name ?? this.name,
      order: order ?? this.order,
      teamIndex:
          identical(teamIndex, _unset) ? this.teamIndex : teamIndex as int?,
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
  final String? selectedCourseId;

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
    this.selectedCourseId,
  });

  factory CreateGameState.fromAggregate(GameAggregate aggregate) {
    final sortedTeams = aggregate.teams.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final teamIdToIndex = {
      for (var i = 0; i < sortedTeams.length; i++) sortedTeams[i].id: i,
    };

    final players =
        (aggregate.players.toList()..sort((a, b) => a.order.compareTo(b.order)))
            .map(
              (p) => PlayerDraft(
                name: p.name,
                order: p.order,
                teamIndex: p.teamId != null ? teamIdToIndex[p.teamId!] : null,
              ),
            )
            .toList();

    final teams = sortedTeams
        .map((t) => TeamDraft(name: t.name, order: t.order))
        .toList();

    final holes = (aggregate.holeConfigs.toList()
          ..sort((a, b) => a.holeNumber.compareTo(b.holeNumber)))
        .map(
          (h) => HoleConfigDraft(
            holeNumber: h.holeNumber,
            par: h.par,
            isTurbo: h.isTurbo,
            isBirdieBonus: h.isBirdieBonus,
          ),
        )
        .toList();

    return CreateGameState(
      title: aggregate.game.title,
      mode: aggregate.game.mode,
      players: players,
      teams: teams,
      bestOneEnabled: aggregate.settings.bestOneEnabled,
      bestTwoEnabled: aggregate.settings.bestTwoEnabled,
      sharedBetDefault: aggregate.settings.sharedBetDefault,
      bestOneAmount: aggregate.settings.bestOneAmount,
      bestTwoAmount: aggregate.settings.bestTwoAmount,
      holes: holes,
      isSubmitting: false,
      errorMessage: null,
    );
  }

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
    Object? bestOneAmount = _unset,
    Object? bestTwoAmount = _unset,
    List<HoleConfigDraft>? holes,
    bool? isSubmitting,
    String? errorMessage,
    Object? selectedCourseId = _unset,
  }) {
    return CreateGameState(
      title: title ?? this.title,
      mode: mode ?? this.mode,
      players: players ?? this.players,
      teams: teams ?? this.teams,
      bestOneEnabled: bestOneEnabled ?? this.bestOneEnabled,
      bestTwoEnabled: bestTwoEnabled ?? this.bestTwoEnabled,
      sharedBetDefault: sharedBetDefault ?? this.sharedBetDefault,
      bestOneAmount: identical(bestOneAmount, _unset)
          ? this.bestOneAmount
          : bestOneAmount as int?,
      bestTwoAmount: identical(bestTwoAmount, _unset)
          ? this.bestTwoAmount
          : bestTwoAmount as int?,
      holes: holes ?? this.holes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      selectedCourseId: identical(selectedCourseId, _unset)
          ? this.selectedCourseId
          : selectedCourseId as String?,
    );
  }
}
