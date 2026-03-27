import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/computed_hole_results_table.dart';
import '../tables/settlement_snapshots_table.dart';

part 'calculation_dao.g.dart';

@DriftAccessor(
  tables: [
    ComputedHoleResultsTable,
    SettlementSnapshotsTable,
  ],
)
class CalculationDao extends DatabaseAccessor<AppDatabase>
    with _$CalculationDaoMixin {
  CalculationDao(super.db);

  Future<void> replaceCalculationResult({
    required String gameId,
    required List<ComputedHoleResultsTableCompanion> holeResults,
    required SettlementSnapshotsTableCompanion settlement,
  }) async {
    await transaction(() async {
      await (delete(computedHoleResultsTable)
            ..where((tbl) => tbl.gameId.equals(gameId)))
          .go();

      if (holeResults.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(computedHoleResultsTable, holeResults);
        });
      }

      await into(settlementSnapshotsTable).insertOnConflictUpdate(settlement);
    });
  }
}
