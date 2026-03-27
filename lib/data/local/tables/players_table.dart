import 'package:drift/drift.dart';

class PlayersTable extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text()();
  TextColumn get name => text()();
  IntColumn get playerOrder => integer()();
  TextColumn get teamId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
