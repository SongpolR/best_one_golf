import 'dart:convert';

import '../../data/local/app_database.dart';
import '../entities/hole_result_view_data.dart';

class LoadHoleResultUseCase {
  final AppDatabase db;

  const LoadHoleResultUseCase(this.db);

  Stream<HoleResultViewData?> watch({
    required String gameId,
    required int holeNumber,
  }) {
    return db.resultViewDao
        .watchHoleResult(gameId: gameId, holeNumber: holeNumber)
        .map((row) {
      if (row == null) return null;

      final json = jsonDecode(row.summaryJson) as Map<String, dynamic>;

      return HoleResultViewData(
        holeNumber: json['holeNumber'] as int,
        isComplete: json['isComplete'] as bool,
        isTurbo: json['isTurbo'] as bool? ?? false,
        isBirdieBonus: json['isBirdieBonus'] as bool? ?? false,
        baseAmount: json['baseAmount'] as int?,
        playerMovements: ((json['movements'] as List?) ?? [])
            .map(
              (item) => HoleMovementViewData(
                fromId: item['fromId'] as String,
                toId: item['toId'] as String,
                amount: item['amount'] as int,
                rule: item['rule'] as String,
                note: item['note'] as String,
              ),
            )
            .toList(),
        teamMovements: ((json['teamMovements'] as List?) ?? [])
            .map(
              (item) => HoleTeamMovementViewData(
                fromTeamId: item['fromTeamId'] as String,
                toTeamId: item['toTeamId'] as String,
                amount: item['amount'] as int,
                rule: item['rule'] as String,
                note: item['note'] as String,
              ),
            )
            .toList(),
        playerNet: ((json['playerNet'] as Map?) ?? {})
            .map((key, value) => MapEntry(key as String, value as int)),
        teamNet: ((json['teamNet'] as Map?) ?? {})
            .map((key, value) => MapEntry(key as String, value as int)),
      );
    });
  }
}
