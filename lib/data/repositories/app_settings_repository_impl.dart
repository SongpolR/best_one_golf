import '../../core/enums/app_currency.dart';
import '../../core/enums/app_language.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../local/app_database.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppDatabase db;

  AppSettingsRepositoryImpl(this.db);

  @override
  Future<AppSettings> getSettings() async {
    final row = await db.appSettingsDao.getSettings();
    return AppSettings(
      language: AppLanguage.fromCode(row.languageCode),
      currency: AppCurrency.fromCode(row.currencyCode),
    );
  }

  @override
  Stream<AppSettings> watchSettings() {
    return db.appSettingsDao.watchSettings().map(
          (row) => AppSettings(
            language: AppLanguage.fromCode(row.languageCode),
            currency: AppCurrency.fromCode(row.currencyCode),
          ),
        );
  }

  @override
  Future<void> updateCurrency(AppCurrency currency) {
    return db.appSettingsDao.updateCurrency(currency.code);
  }

  @override
  Future<void> updateLanguage(AppLanguage language) {
    return db.appSettingsDao.updateLanguage(language.code);
  }
}
