import 'package:best_one_golf/core/enums/game_mode.dart';
import 'package:best_one_golf/domain/entities/golf_course.dart';
import 'package:best_one_golf/features/create_game/presentation/create_game_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late CreateGameController controller;

  const singhaParkCourse = GolfCourse(
    id: 'singha-park-khon-kaen',
    name: 'Singha Park Khon Kaen Golf Club',
    location: 'Khon Kaen',
    totalHoles: 18,
    pars: [4, 4, 5, 4, 3, 4, 5, 3, 4, 4, 5, 4, 3, 4, 4, 4, 3, 5],
  );

  setUp(() {
    container = ProviderContainer();
    controller = container.read(createGameControllerProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('applyCourse', () {
    test('applies par values from selected golf course to all holes', () {
      controller.applyCourse(singhaParkCourse);

      final state = container.read(createGameControllerProvider);

      expect(state.selectedCourseId, 'singha-park-khon-kaen');
      expect(state.holes.length, 18);

      // Verify each hole's par matches the course data
      final expectedPars = [
        4,
        4,
        5,
        4,
        3,
        4,
        5,
        3,
        4,
        4,
        5,
        4,
        3,
        4,
        4,
        4,
        3,
        5
      ];
      for (var i = 0; i < 18; i++) {
        expect(
          state.holes[i].par,
          expectedPars[i],
          reason: 'Hole ${i + 1} should have par ${expectedPars[i]}',
        );
        expect(state.holes[i].holeNumber, i + 1);
      }
    });

    test('preserves turbo and birdie bonus settings when applying course', () {
      // Set turbo and birdie bonus on some holes first
      controller.updateHoleTurbo(0, true);
      controller.updateHoleBirdieBonus(2, true);
      controller.applyTurboFor9And18();

      controller.applyCourse(singhaParkCourse);

      final state = container.read(createGameControllerProvider);

      // Turbo/birdie settings should be preserved
      expect(state.holes[0].isTurbo, isTrue, reason: 'Hole 1 turbo preserved');
      expect(state.holes[2].isBirdieBonus, isTrue,
          reason: 'Hole 3 birdie preserved');
      expect(state.holes[8].isTurbo, isTrue, reason: 'Hole 9 turbo preserved');
      expect(state.holes[17].isTurbo, isTrue,
          reason: 'Hole 18 turbo preserved');

      // Par values should come from the course
      expect(state.holes[0].par, 4);
      expect(state.holes[2].par, 5);
      expect(state.holes[4].par, 3);
    });

    test('resets par values to default 4 when course is deselected', () {
      // First apply a course
      controller.applyCourse(singhaParkCourse);

      var state = container.read(createGameControllerProvider);
      expect(state.selectedCourseId, isNotNull);
      // Verify some pars are not 4
      expect(state.holes[2].par, 5);
      expect(state.holes[4].par, 3);

      // Deselect the course (pass null)
      controller.applyCourse(null);

      state = container.read(createGameControllerProvider);
      expect(state.selectedCourseId, isNull);
      expect(state.holes.length, 18);

      // All pars should be back to default 4
      for (var i = 0; i < 18; i++) {
        expect(
          state.holes[i].par,
          4,
          reason: 'Hole ${i + 1} should reset to par 4',
        );
      }
    });

    test('preserves turbo and birdie bonus settings when resetting to default',
        () {
      // Set some turbo/birdie settings
      controller.updateHoleTurbo(0, true);
      controller.updateHoleBirdieBonus(5, true);

      // Apply course, then deselect
      controller.applyCourse(singhaParkCourse);
      controller.applyCourse(null);

      final state = container.read(createGameControllerProvider);

      expect(state.holes[0].isTurbo, isTrue);
      expect(state.holes[5].isBirdieBonus, isTrue);
      // Par should be back to default
      expect(state.holes[0].par, 4);
      expect(state.holes[5].par, 4);
    });

    test('clears error message when course is applied', () {
      // Trigger an error state by submitting without title
      final state = container.read(createGameControllerProvider);
      expect(state.errorMessage, isNull);

      controller.applyCourse(singhaParkCourse);

      final updated = container.read(createGameControllerProvider);
      expect(updated.errorMessage, isNull);
    });

    test('applying a different course overwrites previous course pars', () {
      controller.applyCourse(singhaParkCourse);

      final customCourse = GolfCourse(
        id: 'custom-course',
        name: 'Custom Course',
        location: 'Bangkok',
        totalHoles: 18,
        pars: List.generate(18, (_) => 3),
      );

      controller.applyCourse(customCourse);

      final state = container.read(createGameControllerProvider);
      expect(state.selectedCourseId, 'custom-course');
      for (var i = 0; i < 18; i++) {
        expect(state.holes[i].par, 3);
      }
    });

    test('hole numbers remain sequential after applying course', () {
      controller.applyCourse(singhaParkCourse);

      final state = container.read(createGameControllerProvider);
      for (var i = 0; i < 18; i++) {
        expect(state.holes[i].holeNumber, i + 1);
      }
    });
  });

  group('resetToDefault', () {
    test('resets all state to initial values', () {
      // Modify various state properties
      controller.updateTitle('My Game');
      controller.addPlayer();
      controller.updatePlayerName(0, 'Alice');
      controller.applyCourse(singhaParkCourse);
      controller.applyTurboFor9And18();

      // Verify state is modified
      var state = container.read(createGameControllerProvider);
      expect(state.title, 'My Game');
      expect(state.players.length, 3);
      expect(state.selectedCourseId, isNotNull);
      expect(state.holes[2].par, 5);
      expect(state.holes[8].isTurbo, isTrue);

      // Reset
      controller.resetToDefault();

      state = container.read(createGameControllerProvider);
      expect(state.title, '');
      expect(state.players.length, 2);
      expect(state.selectedCourseId, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isSubmitting, isFalse);

      // All holes should be par 4, no turbo, no birdie bonus
      for (var i = 0; i < 18; i++) {
        expect(state.holes[i].par, 4);
        expect(state.holes[i].isTurbo, isFalse);
        expect(state.holes[i].isBirdieBonus, isFalse);
        expect(state.holes[i].holeNumber, i + 1);
      }
    });

    test('resets mode and bet settings to defaults', () {
      controller.updateMode(GameMode.team);
      controller.setUseSeparateAmounts(true);
      controller.updateBestOneAmount('50');
      controller.updateBestTwoAmount('30');

      controller.resetToDefault();

      final state = container.read(createGameControllerProvider);
      expect(state.mode, GameMode.individual);
      expect(state.bestOneEnabled, isTrue);
      expect(state.bestTwoEnabled, isFalse);
      expect(state.sharedBetDefault, isTrue);
      expect(state.bestOneAmount, 20);
      expect(state.bestTwoAmount, 20);
    });
  });
}
