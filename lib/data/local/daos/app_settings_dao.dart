import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/app_settings_table.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable])
class AppSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  Stream<AppSettingsTableData> watchSettings() {
    return select(appSettingsTable).watchSingle();
  }

  Future<AppSettingsTableData> getSettings() {
    return select(appSettingsTable).getSingle();
  }

  Future<void> ensureSeeded() async {
    final existing = await select(appSettingsTable).getSingleOrNull();
    if (existing != null) return;

    await into(appSettingsTable).insert(
      const AppSettingsTableCompanion(
        id: Value(1),
        languageCode: Value('en'),
        currencyCode: Value('USD'),
      ),
    );
  }

  Future<void> updateLanguage(String code) {
    return (update(appSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
      AppSettingsTableCompanion(
        languageCode: Value(code),
      ),
    );
  }

  Future<void> updateCurrency(String code) {
    return (update(appSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
      AppSettingsTableCompanion(
        currencyCode: Value(code),
      ),
    );
  }
}
