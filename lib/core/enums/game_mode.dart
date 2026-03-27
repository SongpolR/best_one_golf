enum GameMode {
  individual('individual'),
  team('team');

  final String value;
  const GameMode(this.value);

  static GameMode fromValue(String value) {
    return GameMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => GameMode.individual,
    );
  }
}
