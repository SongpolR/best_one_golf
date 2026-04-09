import '../../core/enums/app_currency.dart';
import '../../core/enums/app_language.dart';
import '../../core/enums/app_theme_mode.dart';

class AppSettings {
  final AppLanguage language;
  final AppCurrency currency;
  final AppThemeMode themeMode;
  final bool adsRemoved;

  const AppSettings({
    required this.language,
    required this.currency,
    required this.themeMode,
    this.adsRemoved = false,
  });

  AppSettings copyWith({
    AppLanguage? language,
    AppCurrency? currency,
    AppThemeMode? themeMode,
    bool? adsRemoved,
  }) {
    return AppSettings(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      adsRemoved: adsRemoved ?? this.adsRemoved,
    );
  }
}
