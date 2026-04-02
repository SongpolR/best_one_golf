import '../../core/enums/app_currency.dart';
import '../../core/enums/app_language.dart';
import '../../core/enums/app_theme_mode.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../local/app_database.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppDatabase db;

  AppSettingsRepositoryImpl(this.db);

  AppSettings _fromRow(AppSettingsTableData row) {
    return AppSettings(
      language: AppLanguage.fromCode(row.languageCode),
      currency: AppCurrency.fromCode(row.currencyCode),
      themeMode: AppThemeMode.fromCode(row.themeModeCode),
      adsRemoved: row.adsRemoved,
    );
  }

  @override
  Future<AppSettings> getSettings() async {
    final row = await db.appSettingsDao.getSettings();
    return _fromRow(row);
  }

  @override
  Stream<AppSettings> watchSettings() {
    return db.appSettingsDao.watchSettings().map(_fromRow);
  }

  @override
  Future<void> updateCurrency(AppCurrency currency) {
    return db.appSettingsDao.updateCurrency(currency.code);
  }

  @override
  Future<void> updateLanguage(AppLanguage language) {
    return db.appSettingsDao.updateLanguage(language.code);
  }

  @override
  Future<void> updateThemeMode(AppThemeMode mode) {
    return db.appSettingsDao.updateThemeMode(mode.code);
  }

  @override
  Future<void> updateAdsRemoved(bool removed) {
    return db.appSettingsDao.updateAdsRemoved(removed);
  }
}
