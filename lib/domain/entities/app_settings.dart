import '../../core/enums/app_currency.dart';
import '../../core/enums/app_language.dart';

class AppSettings {
  final AppLanguage language;
  final AppCurrency currency;

  const AppSettings({
    required this.language,
    required this.currency,
  });

  AppSettings copyWith({
    AppLanguage? language,
    AppCurrency? currency,
  }) {
    return AppSettings(
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }
}
