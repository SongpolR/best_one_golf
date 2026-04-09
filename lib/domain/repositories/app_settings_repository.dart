import '../../core/enums/app_currency.dart';
import '../../core/enums/app_language.dart';
import '../../core/enums/app_theme_mode.dart';
import '../entities/app_settings.dart';

abstract class AppSettingsRepository {
  Stream<AppSettings> watchSettings();
  Future<AppSettings> getSettings();
  Future<void> updateLanguage(AppLanguage language);
  Future<void> updateCurrency(AppCurrency currency);
  Future<void> updateThemeMode(AppThemeMode mode);
  Future<void> updateAdsRemoved(bool removed);
}
