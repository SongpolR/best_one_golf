import 'package:drift/drift.dart';

class AppSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get languageCode => text().withDefault(const Constant('th'))();
  TextColumn get currencyCode => text().withDefault(const Constant('THB'))();
  TextColumn get themeModeCode =>
      text().withDefault(const Constant('system'))();
  BoolColumn get adsRemoved => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
