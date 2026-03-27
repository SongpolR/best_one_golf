import 'package:drift/drift.dart';

class SettlementSnapshotsTable extends Table {
  TextColumn get gameId => text()();
  TextColumn get summaryJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {gameId};
}
