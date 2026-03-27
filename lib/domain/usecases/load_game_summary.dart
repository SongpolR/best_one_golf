import 'dart:convert';

import '../../data/local/app_database.dart';
import '../entities/game_summary_view_data.dart';

class LoadGameSummaryUseCase {
  final AppDatabase db;

  const LoadGameSummaryUseCase(this.db);

  Stream<GameSummaryViewData?> watch(String gameId) {
    return db.resultViewDao.watchGameSummary(gameId).map((row) {
      if (row == null) return null;

      final json = jsonDecode(row.summaryJson) as Map<String, dynamic>;

      return GameSummaryViewData(
        totalByPlayer: ((json['totalByPlayer'] as Map?) ?? {})
            .map((key, value) => MapEntry(key as String, value as int)),
        settlements: ((json['settlements'] as List?) ?? [])
            .map(
              (item) => GameSettlementViewData(
                fromId: item['fromId'] as String,
                toId: item['toId'] as String,
                amount: item['amount'] as int,
              ),
            )
            .toList(),
      );
    });
  }
}
