import 'dart:async';

import 'package:best_one_golf/domain/entities/game_summary_view_data.dart';

class FakeLoadGameSummaryUseCase {
  FakeLoadGameSummaryUseCase({
    GameSummaryViewData? initialValue,
  }) : _value = initialValue;

  GameSummaryViewData? _value;
  GameSummaryViewData? get initialValue => _value;

  final _controller = StreamController<GameSummaryViewData?>.broadcast();

  Stream<GameSummaryViewData?> watch(String gameId) async* {
    yield _value;
    yield* _controller.stream;
  }

  void emit(GameSummaryViewData? value) {
    _value = value;
    _controller.add(value);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
