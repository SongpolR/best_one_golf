import 'game.dart';
import 'game_rule_settings.dart';
import 'hole_config.dart';
import 'hole_score.dart';
import 'player.dart';
import 'team.dart';

class GameAggregate {
  final Game game;
  final GameRuleSettings settings;
  final List<Player> players;
  final List<Team> teams;
  final List<HoleConfig> holeConfigs;
  final List<HoleScore> holeScores;

  const GameAggregate({
    required this.game,
    required this.settings,
    required this.players,
    required this.teams,
    required this.holeConfigs,
    required this.holeScores,
  });
}
