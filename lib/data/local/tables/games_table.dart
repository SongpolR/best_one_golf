import 'package:drift/drift.dart';

class GamesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get mode => text()(); // individual | team
  TextColumn get status => text().withDefault(const Constant('ongoing'))();
  IntColumn get totalHoles => integer().withDefault(const Constant(18))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
