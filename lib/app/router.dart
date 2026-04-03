import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/game_aggregate.dart';
import '../features/create_game/presentation/create_game_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/score_entry/presentation/score_entry_screen.dart';
import '../features/settings/presentation/policy_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/game_summary/presentation/game_summary_screen.dart';
import '../features/hole_result/presentation/hole_result_screen.dart';

/// Slide-in from the right with a quick leading fade.
/// Used for all secondary-route pushes.
CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnim = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      );

      // Fade in the first 40 % of the animation for a smooth entrance.
      final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
        ),
      );

      // Slightly dim / slide out the current page on push.
      final secondarySlideAnim = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.08, 0.0),
      ).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic),
      );

      final secondaryFadeAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic),
      );

      return SlideTransition(
        position: secondarySlideAnim,
        child: FadeTransition(
          opacity: secondaryFadeAnim,
          child: FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

/// Simple fade transition — used for the root (home) route.
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      );
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _fadePage(state, const HomeScreen()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _slidePage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/create-game',
        pageBuilder: (context, state) {
          final template = state.extra as GameAggregate?;
          return _slidePage(state, CreateGameScreen(template: template));
        },
      ),
      GoRoute(
        path: '/history',
        pageBuilder: (context, state) =>
            _slidePage(state, const HistoryScreen()),
      ),
      GoRoute(
        path: '/score-entry/:gameId',
        pageBuilder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return _slidePage(state, ScoreEntryScreen(gameId: gameId));
        },
      ),
      GoRoute(
        path: '/hole-result/:gameId/:holeNumber',
        pageBuilder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          final holeNumber = int.parse(state.pathParameters['holeNumber']!);
          return _slidePage(
            state,
            HoleResultScreen(gameId: gameId, holeNumber: holeNumber),
          );
        },
      ),
      GoRoute(
        path: '/game-summary/:gameId',
        pageBuilder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return _slidePage(state, GameSummaryScreen(gameId: gameId));
        },
      ),
      GoRoute(
        path: '/terms',
        pageBuilder: (context, state) =>
            _slidePage(state, const PolicyScreen(type: PolicyType.terms)),
      ),
      GoRoute(
        path: '/privacy-policy',
        pageBuilder: (context, state) =>
            _slidePage(state, const PolicyScreen(type: PolicyType.privacy)),
      ),
    ],
  );
});
