enum AppThemeMode {
  system('system'),
  light('light'),
  dark('dark');

  const AppThemeMode(this.code);

  final String code;

  static AppThemeMode fromCode(String code) {
    return AppThemeMode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AppThemeMode.system,
    );
  }
}
