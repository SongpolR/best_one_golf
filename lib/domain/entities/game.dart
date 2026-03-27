import '../../core/enums/game_mode.dart';

class Game {
  final String id;
  final String title;
  final GameMode mode;
  final String status;
  final int totalHoles;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Game({
    required this.id,
    required this.title,
    required this.mode,
    required this.status,
    required this.totalHoles,
    required this.createdAt,
    required this.updatedAt,
  });
}
