import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../domain/entities/game_list_item.dart';

const int _pageSize = 10;

class GamePageState {
  final List<GameListItem> items;
  final bool isLoading;
  final bool hasMore;

  const GamePageState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
  });

  const GamePageState.initial()
      : items = const [],
        isLoading = true,
        hasMore = false;

  GamePageState copyWith({
    List<GameListItem>? items,
    bool? isLoading,
    bool? hasMore,
  }) {
    return GamePageState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class HistoryState {
  final GamePageState ongoing;
  final GamePageState completed;

  const HistoryState({
    required this.ongoing,
    required this.completed,
  });

  const HistoryState.initial()
      : ongoing = const GamePageState.initial(),
        completed = const GamePageState.initial();

  HistoryState copyWith({
    GamePageState? ongoing,
    GamePageState? completed,
  }) {
    return HistoryState(
      ongoing: ongoing ?? this.ongoing,
      completed: completed ?? this.completed,
    );
  }
}

final historyControllerProvider =
    AutoDisposeNotifierProvider<HistoryController, HistoryState>(
  HistoryController.new,
);

class HistoryController extends AutoDisposeNotifier<HistoryState> {
  @override
  HistoryState build() {
    Future.microtask(() async {
      await Future.wait([
        _loadOngoing(reset: true),
        _loadCompleted(reset: true),
      ]);
    });
    return const HistoryState.initial();
  }

  Future<void> _loadOngoing({bool reset = false}) async {
    final current = state.ongoing;
    final offset = reset ? 0 : current.items.length;

    state = state.copyWith(
      ongoing: current.copyWith(isLoading: true),
    );

    final repository = ref.read(gameRepositoryProvider);
    final fetched = await repository.fetchOngoingGames(
      limit: _pageSize,
      offset: offset,
    );

    final items = reset ? fetched : [...current.items, ...fetched];
    state = state.copyWith(
      ongoing: GamePageState(
        items: items,
        isLoading: false,
        hasMore: fetched.length >= _pageSize,
      ),
    );
  }

  Future<void> _loadCompleted({bool reset = false}) async {
    final current = state.completed;
    final offset = reset ? 0 : current.items.length;

    state = state.copyWith(
      completed: current.copyWith(isLoading: true),
    );

    final repository = ref.read(gameRepositoryProvider);
    final fetched = await repository.fetchCompletedGames(
      limit: _pageSize,
      offset: offset,
    );

    final items = reset ? fetched : [...current.items, ...fetched];
    state = state.copyWith(
      completed: GamePageState(
        items: items,
        isLoading: false,
        hasMore: fetched.length >= _pageSize,
      ),
    );
  }

  Future<void> loadMoreOngoing() async {
    if (state.ongoing.isLoading || !state.ongoing.hasMore) return;
    await _loadOngoing();
  }

  Future<void> loadMoreCompleted() async {
    if (state.completed.isLoading || !state.completed.hasMore) return;
    await _loadCompleted();
  }

  Future<void> refresh() async {
    await Future.wait([
      _loadOngoing(reset: true),
      _loadCompleted(reset: true),
    ]);
  }
}
