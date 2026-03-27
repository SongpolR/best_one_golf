enum AppCurrency {
  usd('USD'),
  thb('THB');

  final String code;
  const AppCurrency(this.code);

  static AppCurrency fromCode(String code) {
    return AppCurrency.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AppCurrency.usd,
    );
  }
}
