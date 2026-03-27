import 'package:drift/drift.dart';

class ComputedHoleResultsTable extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text()();
  IntColumn get holeNumber => integer()();
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();
  TextColumn get summaryJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}
