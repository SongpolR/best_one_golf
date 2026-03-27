import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class ScoreEntryScreen extends StatelessWidget {
  final String gameId;

  const ScoreEntryScreen({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Score Entry',
      body: Center(
        child: Text('Score Entry Placeholder\nGame ID: $gameId'),
      ),
    );
  }
}
