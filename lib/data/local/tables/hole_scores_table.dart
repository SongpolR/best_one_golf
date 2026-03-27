import 'package:drift/drift.dart';

class HoleScoresTable extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text()();
  IntColumn get holeNumber => integer()();
  TextColumn get playerId => text()();
  IntColumn get strokes => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
