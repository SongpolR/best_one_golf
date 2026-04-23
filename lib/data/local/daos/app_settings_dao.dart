import 'dart:ui';

import 'package:drift/drift.dart';

import '../../../core/enums/app_currency.dart';
import '../../../core/enums/app_language.dart';
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

    final deviceLocale = PlatformDispatcher.instance.locale.languageCode;
    final language = AppLanguage.fromCode(deviceLocale);
    final currency =
        language == AppLanguage.th ? AppCurrency.thb : AppCurrency.usd;

    await into(appSettingsTable).insert(
      AppSettingsTableCompanion(
        id: const Value(1),
        languageCode: Value(language.code),
        currencyCode: Value(currency.code),
        themeModeCode: const Value('system'),
        adsRemoved: const Value(false),
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

  Future<void> updateThemeMode(String code) {
    return (update(appSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
      AppSettingsTableCompanion(
        themeModeCode: Value(code),
      ),
    );
  }

  Future<void> updateAdsRemoved(bool removed) {
    return (update(appSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
      AppSettingsTableCompanion(
        adsRemoved: Value(removed),
      ),
    );
  }
}
