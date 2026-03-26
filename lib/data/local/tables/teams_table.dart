import 'package:drift/drift.dart';

class TeamsTable extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text()();
  TextColumn get name => text()();
  IntColumn get teamOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}