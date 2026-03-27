import 'package:drift/drift.dart';

class HoleConfigsTable extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text()();
  IntColumn get holeNumber => integer()();
  IntColumn get par => integer().withDefault(const Constant(4))();
  BoolColumn get isTurbo => boolean().withDefault(const Constant(false))();
  BoolColumn get isBirdieBonus =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
