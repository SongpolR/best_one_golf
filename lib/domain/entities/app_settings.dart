import '../../core/enums/app_currency.dart';
import '../../core/enums/app_language.dart';
import '../../core/enums/app_theme_mode.dart';

class AppSettings {
  final AppLanguage language;
  final AppCurrency currency;
  final AppThemeMode themeMode;

  const AppSettings({
    required this.language,
    required this.currency,
    required this.themeMode,
  });

  AppSettings copyWith({
    AppLanguage? language,
    AppCurrency? currency,
    AppThemeMode? themeMode,
  }) {
    return AppSettings(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
