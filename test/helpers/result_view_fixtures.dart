import 'package:best_one_golf/domain/entities/game_summary_view_data.dart';
import 'package:best_one_golf/domain/entities/hole_result_view_data.dart';

HoleResultViewData fakeHoleResultViewData({
  int holeNumber = 1,
  bool isComplete = true,
}) {
  return HoleResultViewData(
    holeNumber: holeNumber,
    isComplete: isComplete,
    isTurbo: true,
    isBirdieBonus: false,
    baseAmount: 20,
    playerMovements: const [
      HoleMovementViewData(
        fromId: 'p2',
        toId: 'p1',
        amount: 20,
        rule: 'individual',
        note: 'gross',
      ),
    ],
    teamMovements: const [],
    playerNet: const {
      'p1': 20,
      'p2': -20,
    },
    teamNet: const {},
  );
}

HoleResultViewData fakeTeamHoleResultViewData({
  int holeNumber = 1,
}) {
  return HoleResultViewData(
    holeNumber: holeNumber,
    isComplete: true,
    isTurbo: false,
    isBirdieBonus: true,
    baseAmount: 20,
    playerMovements: const [
      HoleMovementViewData(
        fromId: 'p3',
        toId: 'p1',
        amount: 10,
        rule: 'best_one',
        note: 'team_split',
      ),
      HoleMovementViewData(
        fromId: 'p4',
        toId: 'p2',
        amount: 10,
        rule: 'best_one',
        note: 'team_split',
      ),
    ],
    teamMovements: const [
      HoleTeamMovementViewData(
        fromTeamId: 't2',
        toTeamId: 't1',
        amount: 20,
        rule: 'best_one',
        note: 'team',
      ),
    ],
    playerNet: const {
      'p1': 10,
      'p2': 10,
      'p3': -10,
      'p4': -10,
    },
    teamNet: const {
      't1': 20,
      't2': -20,
    },
  );
}

GameSummaryViewData fakeGameSummaryViewData() {
  return const GameSummaryViewData(
    totalByPlayer: {
      'p1': 100,
      'p2': -40,
      'p3': -60,
    },
    settlements: [
      GameSettlementViewData(
        fromId: 'p2',
        toId: 'p1',
        amount: 40,
      ),
      GameSettlementViewData(
        fromId: 'p3',
        toId: 'p1',
        amount: 60,
      ),
    ],
  );
}
