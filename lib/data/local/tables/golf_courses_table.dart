import 'package:drift/drift.dart';

class GolfCoursesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get location => text()();
  IntColumn get totalHoles => integer().withDefault(const Constant(18))();

  /// Comma-separated par values per hole, e.g. "4,4,5,4,3,4,5,3,4,4,5,4,3,4,4,4,3,5"
  TextColumn get pars => text()();

  @override
  Set<Column> get primaryKey => {id};
}
