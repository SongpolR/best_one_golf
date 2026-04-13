// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_dao.dart';

// ignore_for_file: type=lint
mixin _$CalculationDaoMixin on DatabaseAccessor<AppDatabase> {
  $ComputedHoleResultsTableTable get computedHoleResultsTable =>
      attachedDatabase.computedHoleResultsTable;
  $SettlementSnapshotsTableTable get settlementSnapshotsTable =>
      attachedDatabase.settlementSnapshotsTable;
  CalculationDaoManager get managers => CalculationDaoManager(this);
}

class CalculationDaoManager {
  final _$CalculationDaoMixin _db;
  CalculationDaoManager(this._db);
  $$ComputedHoleResultsTableTableTableManager get computedHoleResultsTable =>
      $$ComputedHoleResultsTableTableTableManager(
          _db.attachedDatabase, _db.computedHoleResultsTable);
  $$SettlementSnapshotsTableTableTableManager get settlementSnapshotsTable =>
      $$SettlementSnapshotsTableTableTableManager(
          _db.attachedDatabase, _db.settlementSnapshotsTable);
}
