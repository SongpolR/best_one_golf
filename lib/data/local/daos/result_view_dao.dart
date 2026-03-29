import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/computed_hole_results_table.dart';
import '../tables/settlement_snapshots_table.dart';

part 'result_view_dao.g.dart';

@DriftAccessor(
  tables: [
    ComputedHoleResultsTable,
    SettlementSnapshotsTable,
  ],
)
class ResultViewDao extends DatabaseAccessor<AppDatabase>
    with _$ResultViewDaoMixin {
  ResultViewDao(super.db);

  Future<ComputedHoleResultsTableData?> getHoleResult({
    required String gameId,
    required int holeNumber,
  }) {
    return (select(computedHoleResultsTable)
          ..where((tbl) =>
              tbl.gameId.equals(gameId) & tbl.holeNumber.equals(holeNumber)))
        .getSingleOrNull();
  }

  Stream<ComputedHoleResultsTableData?> watchHoleResult({
    required String gameId,
    required int holeNumber,
  }) {
    return (select(computedHoleResultsTable)
          ..where((tbl) =>
              tbl.gameId.equals(gameId) & tbl.holeNumber.equals(holeNumber)))
        .watchSingleOrNull();
  }

  Future<SettlementSnapshotsTableData?> getGameSummary(String gameId) {
    return (select(settlementSnapshotsTable)
          ..where((tbl) => tbl.gameId.equals(gameId)))
        .getSingleOrNull();
  }

  Stream<SettlementSnapshotsTableData?> watchGameSummary(String gameId) {
    return (select(settlementSnapshotsTable)
          ..where((tbl) => tbl.gameId.equals(gameId)))
        .watchSingleOrNull();
  }
}
