// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_view_dao.dart';

// ignore_for_file: type=lint
mixin _$ResultViewDaoMixin on DatabaseAccessor<AppDatabase> {
  $ComputedHoleResultsTableTable get computedHoleResultsTable =>
      attachedDatabase.computedHoleResultsTable;
  $SettlementSnapshotsTableTable get settlementSnapshotsTable =>
      attachedDatabase.settlementSnapshotsTable;
  ResultViewDaoManager get managers => ResultViewDaoManager(this);
}

class ResultViewDaoManager {
  final _$ResultViewDaoMixin _db;
  ResultViewDaoManager(this._db);
  $$ComputedHoleResultsTableTableTableManager get computedHoleResultsTable =>
      $$ComputedHoleResultsTableTableTableManager(
          _db.attachedDatabase, _db.computedHoleResultsTable);
  $$SettlementSnapshotsTableTableTableManager get settlementSnapshotsTable =>
      $$SettlementSnapshotsTableTableTableManager(
          _db.attachedDatabase, _db.settlementSnapshotsTable);
}
