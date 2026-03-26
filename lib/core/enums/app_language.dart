enum AppLanguage {
  en('en'),
  th('th');

  final String code;
  const AppLanguage(this.code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AppLanguage.en,
    );
  }
}
