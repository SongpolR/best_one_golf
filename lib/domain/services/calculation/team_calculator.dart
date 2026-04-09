import '../../entities/game_calculation_result.dart';
import '../../entities/game_rule_settings.dart';
import '../../entities/hole_config.dart';
import '../../entities/hole_score.dart';
import '../../entities/player.dart';
import '../../entities/team.dart';
import 'multiplier_calculator.dart';

class TeamCalculator {
  final MultiplierCalculator multiplierCalculator;

  const TeamCalculator({
    this.multiplierCalculator = const MultiplierCalculator(),
  });

  HoleCalculationResult compute({
    required List<Player> players,
    required List<Team> teams,
    required List<HoleScore> scores,
    required HoleConfig holeConfig,
    required GameRuleSettings settings,
  }) {
    final scoreMap = <String, int?>{
      for (final score in scores) score.playerId: score.strokes,
    };

    final filledCount =
        players.where((player) => scoreMap[player.id] != null).length;

    if (filledCount < players.length) {
      return HoleCalculationResult.incomplete(
        holeNumber: holeConfig.holeNumber,
        isTurbo: holeConfig.isTurbo,
        isBirdieBonus: holeConfig.isBirdieBonus,
      );
    }

    final playersByTeamId = <String, List<Player>>{};
    for (final player in players) {
      if (player.teamId == null) continue;
      playersByTeamId.putIfAbsent(player.teamId!, () => []).add(player);
    }

    final rankedTeamScores = <String, List<_RankedPlayerScore>>{};
    for (final team in teams) {
      final teamPlayers = playersByTeamId[team.id] ?? [];
      final ranked = teamPlayers
          .map(
            (player) => _RankedPlayerScore(
              player: player,
              score: scoreMap[player.id]!,
            ),
          )
          .toList()
        ..sort((a, b) => a.score.compareTo(b.score));

      rankedTeamScores[team.id] = ranked;
    }

    final playerMovements = <MoneyMovement>[];
    final teamMovements = <TeamMovement>[];
    final playerNet = <String, int>{};
    final teamNet = <String, int>{};

    for (var i = 0; i < teams.length; i++) {
      for (var j = i + 1; j < teams.length; j++) {
        final teamA = teams[i];
        final teamB = teams[j];

        if (settings.bestOneEnabled) {
          _applyRuleComparison(
            ruleName: 'best_one',
            rankIndex: 0,
            teamA: teamA,
            teamB: teamB,
            rankedTeamScores: rankedTeamScores,
            holeConfig: holeConfig,
            baseAmount: settings.bestOneAmount ?? 0,
            teamMovements: teamMovements,
            playerMovements: playerMovements,
            teamNet: teamNet,
            playerNet: playerNet,
          );
        }

        if (settings.bestTwoEnabled) {
          _applyRuleComparison(
            ruleName: 'best_two',
            rankIndex: 1,
            teamA: teamA,
            teamB: teamB,
            rankedTeamScores: rankedTeamScores,
            holeConfig: holeConfig,
            baseAmount: settings.bestTwoAmount ?? 0,
            teamMovements: teamMovements,
            playerMovements: playerMovements,
            teamNet: teamNet,
            playerNet: playerNet,
          );
        }
      }
    }

    return HoleCalculationResult(
      holeNumber: holeConfig.holeNumber,
      isComplete: true,
      movements: playerMovements,
      teamMovements: teamMovements,
      playerNet: playerNet,
      teamNet: teamNet,
      baseAmount: settings.bestOneAmount,
      isTurbo: holeConfig.isTurbo,
      isBirdieBonus: holeConfig.isBirdieBonus,
    );
  }

  void _applyRuleComparison({
    required String ruleName,
    required int rankIndex,
    required Team teamA,
    required Team teamB,
    required Map<String, List<_RankedPlayerScore>> rankedTeamScores,
    required HoleConfig holeConfig,
    required int baseAmount,
    required List<TeamMovement> teamMovements,
    required List<MoneyMovement> playerMovements,
    required Map<String, int> teamNet,
    required Map<String, int> playerNet,
  }) {
    final scoresA = rankedTeamScores[teamA.id] ?? const [];
    final scoresB = rankedTeamScores[teamB.id] ?? const [];

    if (scoresA.length <= rankIndex || scoresB.length <= rankIndex) {
      return;
    }

    final rankedA = scoresA[rankIndex];
    final rankedB = scoresB[rankIndex];

    if (rankedA.score == rankedB.score) {
      return;
    }

    final winnerTeam = rankedA.score < rankedB.score ? teamA : teamB;
    final loserTeam = rankedA.score < rankedB.score ? teamB : teamA;
    final decidingScore =
        rankedA.score < rankedB.score ? rankedA.score : rankedB.score;

    // perLoserAmount is what each losing player pays individually.
    // The total team movement is perLoserAmount × number of losing players.
    final perLoserAmount = multiplierCalculator.apply(
      baseAmount: baseAmount,
      decidingScore: decidingScore,
      par: holeConfig.par,
      isTurbo: holeConfig.isTurbo,
      isBirdieBonus: holeConfig.isBirdieBonus,
    );

    final winnerPlayers =
        rankedTeamScores[winnerTeam.id]!.map((e) => e.player).toList();
    final loserPlayers =
        rankedTeamScores[loserTeam.id]!.map((e) => e.player).toList();

    final teamAmount = perLoserAmount * loserPlayers.length;

    teamMovements.add(
      TeamMovement(
        fromTeamId: loserTeam.id,
        toTeamId: winnerTeam.id,
        amount: teamAmount,
        holeNumber: holeConfig.holeNumber,
        rule: ruleName,
        note: 'team',
      ),
    );

    teamNet[winnerTeam.id] = (teamNet[winnerTeam.id] ?? 0) + teamAmount;
    teamNet[loserTeam.id] = (teamNet[loserTeam.id] ?? 0) - teamAmount;

    final winnerShare = teamAmount ~/ winnerPlayers.length;

    // Sort each side by player order for consistent position-based display.
    final winnerSorted = winnerPlayers.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final loserSorted = loserPlayers.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (loserSorted.length == winnerSorted.length) {
      // Equal teams: match each loser 1-to-1 with the winner at the same
      // position so the display reads "A pays D, B pays E, C pays F".
      for (var k = 0; k < loserSorted.length; k++) {
        playerMovements.add(
          MoneyMovement(
            fromId: loserSorted[k].id,
            toId: winnerSorted[k].id,
            amount: perLoserAmount,
            holeNumber: holeConfig.holeNumber,
            rule: ruleName,
            note: 'team_match',
          ),
        );
      }
    } else {
      // Unequal teams: each loser pays the winning team as a whole.
      // toId is the team ID so the UI can resolve it to a team name.
      for (final loser in loserSorted) {
        playerMovements.add(
          MoneyMovement(
            fromId: loser.id,
            toId: winnerTeam.id,
            amount: perLoserAmount,
            holeNumber: holeConfig.holeNumber,
            rule: ruleName,
            note: 'team_payment',
          ),
        );
      }
    }

    for (final loser in loserPlayers) {
      playerNet[loser.id] = (playerNet[loser.id] ?? 0) - perLoserAmount;
    }

    for (final winner in winnerPlayers) {
      playerNet[winner.id] = (playerNet[winner.id] ?? 0) + winnerShare;
    }
  }
}

class _RankedPlayerScore {
  final Player player;
  final int score;

  const _RankedPlayerScore({
    required this.player,
    required this.score,
  });
}
