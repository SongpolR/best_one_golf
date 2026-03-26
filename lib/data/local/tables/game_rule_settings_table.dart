import 'package:drift/drift.dart';

class GameRuleSettingsTable extends Table {
  TextColumn get gameId => text()();

  BoolColumn get bestOneEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get bestTwoEnabled =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get sharedBetDefault =>
      boolean().withDefault(const Constant(true))();

  IntColumn get bestOneAmount => integer().nullable()();
  IntColumn get bestTwoAmount => integer().nullable()();

  @override
  Set<Column> get primaryKey => {gameId};
}
