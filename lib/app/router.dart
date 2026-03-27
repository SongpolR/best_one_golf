import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/create_game/presentation/create_game_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/score_entry/presentation/score_entry_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/game_summary/presentation/game_summary_screen.dart';
import '../features/hole_result/presentation/hole_result_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/create-game',
        builder: (context, state) => const CreateGameScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/score-entry/:gameId',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return ScoreEntryScreen(gameId: gameId);
        },
      ),
      GoRoute(
        path: '/hole-result/:gameId/:holeNumber',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          final holeNumber = int.parse(state.pathParameters['holeNumber']!);
          return HoleResultScreen(
            gameId: gameId,
            holeNumber: holeNumber,
          );
        },
      ),
      GoRoute(
        path: '/game-summary/:gameId',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return GameSummaryScreen(gameId: gameId);
        },
      ),
    ],
  );
});
