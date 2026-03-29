import 'dart:async';

import 'package:best_one_golf/domain/entities/hole_result_view_data.dart';

class FakeLoadHoleResultUseCase {
  FakeLoadHoleResultUseCase({
    HoleResultViewData? initialValue,
  }) : _value = initialValue;

  HoleResultViewData? _value;
  HoleResultViewData? get initialValue => _value;

  final _controller = StreamController<HoleResultViewData?>.broadcast();

  Stream<HoleResultViewData?> watch({
    required String gameId,
    required int holeNumber,
  }) async* {
    yield _value;
    yield* _controller.stream;
  }

  void emit(HoleResultViewData? value) {
    _value = value;
    _controller.add(value);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
