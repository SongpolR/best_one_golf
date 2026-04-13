import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../domain/entities/game_aggregate.dart';
import '../../domain/entities/hole_config.dart';
import '../../domain/entities/player.dart';

/// Golf score symbol based on strokes relative to par.
///
/// No symbol - Par;
/// Circle - Birdie;
/// Solid circle - Eagle;
/// Solid circle with frame - Albatross or better;
/// Square - Bogey;
/// Solid square - Double bogey;
/// Solid square with frame - Triple bogey or worse.
enum ScoreSymbol {
  par,
  birdie,
  eagle,
  albatrossOrBetter,
  bogey,
  doubleBogey,
  tripleBogeyOrWorse
}

ScoreSymbol getScoreSymbol(int strokes, int par) {
  final diff = strokes - par;
  if (diff == 0) return ScoreSymbol.par;
  if (diff == -1) return ScoreSymbol.birdie;
  if (diff == -2) return ScoreSymbol.eagle;
  if (diff <= -3) return ScoreSymbol.albatrossOrBetter;
  if (diff == 1) return ScoreSymbol.bogey;
  if (diff == 2) return ScoreSymbol.doubleBogey;
  return ScoreSymbol.tripleBogeyOrWorse;
}

class ScorecardTable extends StatelessWidget {
  final GameAggregate aggregate;

  const ScorecardTable({super.key, required this.aggregate});

  static const double _headerColWidth = 80.0;
  static const double _holeColWidth = 48.0;
  static const double _totalColWidth = 56.0;
  static const double _rowHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    final totalHoles = aggregate.game.totalHoles;
    final sortedPlayers = aggregate.players.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final sortedConfigs = aggregate.holeConfigs.toList()
      ..sort((a, b) => a.holeNumber.compareTo(b.holeNumber));

    // Build a lookup: (playerId, holeNumber) -> strokes
    final scoreMap = <(String, int), int?>{};
    for (final s in aggregate.holeScores) {
      scoreMap[(s.playerId, s.holeNumber)] = s.strokes;
    }

    // Build par map
    final parMap = <int, int>{};
    for (final c in sortedConfigs) {
      parMap[c.holeNumber] = c.par;
    }

    final hasBack9 = totalHoles > 9;
    final front9End = hasBack9 ? 9 : totalHoles;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row (Hole numbers)
          _buildHeaderRow(
              context, sortedConfigs, front9End, hasBack9, totalHoles),
          // Par row
          _buildParRow(
              context, sortedConfigs, parMap, front9End, hasBack9, totalHoles),
          const Divider(height: 1, thickness: 1),
          // Player rows
          ...sortedPlayers.map(
            (player) => _buildPlayerRow(
              context,
              player,
              scoreMap,
              parMap,
              sortedConfigs,
              front9End,
              hasBack9,
              totalHoles,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    List<HoleConfig> configs,
    int front9End,
    bool hasBack9,
    int totalHoles,
  ) {
    final theme = Theme.of(context);
    final headerStyle =
        theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      height: _rowHeight,
      child: Row(
        children: [
          _cell(
              width: _headerColWidth, child: Text('Hole', style: headerStyle)),
          for (var i = 1; i <= front9End; i++)
            _cell(width: _holeColWidth, child: Text('$i', style: headerStyle)),
          if (hasBack9)
            _cell(
                width: _totalColWidth, child: Text('OUT', style: headerStyle)),
          if (hasBack9)
            for (var i = front9End + 1; i <= totalHoles; i++)
              _cell(
                  width: _holeColWidth, child: Text('$i', style: headerStyle)),
          _cell(
            width: _totalColWidth,
            child: Text(hasBack9 ? 'IN' : 'TOT', style: headerStyle),
          ),
          if (hasBack9)
            _cell(
                width: _totalColWidth, child: Text('TOT', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildParRow(
    BuildContext context,
    List<HoleConfig> configs,
    Map<int, int> parMap,
    int front9End,
    bool hasBack9,
    int totalHoles,
  ) {
    final theme = Theme.of(context);
    final style =
        theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600);

    int frontPar = 0;
    int backPar = 0;
    for (var i = 1; i <= front9End; i++) {
      frontPar += parMap[i] ?? 0;
    }
    for (var i = front9End + 1; i <= totalHoles; i++) {
      backPar += parMap[i] ?? 0;
    }

    return Container(
      color: theme.colorScheme.surfaceContainerHigh,
      height: _rowHeight,
      child: Row(
        children: [
          _cell(width: _headerColWidth, child: Text('Par', style: style)),
          for (var i = 1; i <= front9End; i++)
            _cell(
                width: _holeColWidth,
                child: Text('${parMap[i] ?? '-'}', style: style)),
          if (hasBack9)
            _cell(
                width: _totalColWidth, child: Text('$frontPar', style: style)),
          if (hasBack9)
            for (var i = front9End + 1; i <= totalHoles; i++)
              _cell(
                  width: _holeColWidth,
                  child: Text('${parMap[i] ?? '-'}', style: style)),
          _cell(
            width: _totalColWidth,
            child: Text(hasBack9 ? '$backPar' : '${frontPar + backPar}',
                style: style),
          ),
          if (hasBack9)
            _cell(
                width: _totalColWidth,
                child: Text('${frontPar + backPar}', style: style)),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(
    BuildContext context,
    Player player,
    Map<(String, int), int?> scoreMap,
    Map<int, int> parMap,
    List<HoleConfig> configs,
    int front9End,
    bool hasBack9,
    int totalHoles,
  ) {
    final theme = Theme.of(context);
    final nameStyle =
        theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600);
    final totalStyle =
        theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700);

    int frontTotal = 0;
    int frontCount = 0;
    int backTotal = 0;
    int backCount = 0;

    for (var i = 1; i <= front9End; i++) {
      final s = scoreMap[(player.id, i)];
      if (s != null) {
        frontTotal += s;
        frontCount++;
      }
    }
    for (var i = front9End + 1; i <= totalHoles; i++) {
      final s = scoreMap[(player.id, i)];
      if (s != null) {
        backTotal += s;
        backCount++;
      }
    }

    return Container(
      height: _rowHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _cell(
            width: _headerColWidth,
            child: Text(
              player.name.isNotEmpty ? player.name : 'P${player.order + 1}',
              style: nameStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          for (var i = 1; i <= front9End; i++)
            _scoreCell(context, scoreMap[(player.id, i)], parMap[i] ?? 4),
          if (hasBack9)
            _cell(
              width: _totalColWidth,
              child:
                  Text(frontCount > 0 ? '$frontTotal' : '-', style: totalStyle),
            ),
          if (hasBack9)
            for (var i = front9End + 1; i <= totalHoles; i++)
              _scoreCell(context, scoreMap[(player.id, i)], parMap[i] ?? 4),
          _cell(
            width: _totalColWidth,
            child: Text(
              hasBack9
                  ? (backCount > 0 ? '$backTotal' : '-')
                  : (frontCount > 0 ? '$frontTotal' : '-'),
              style: totalStyle,
            ),
          ),
          if (hasBack9)
            _cell(
              width: _totalColWidth,
              child: Text(
                (frontCount + backCount) > 0
                    ? '${frontTotal + backTotal}'
                    : '-',
                style: totalStyle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _scoreCell(BuildContext context, int? strokes, int par) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall;

    if (strokes == null) {
      return _cell(
        width: _holeColWidth,
        child: Text('-', style: style?.copyWith(color: AppColors.cloud)),
      );
    }

    final symbol = getScoreSymbol(strokes, par);
    return SizedBox(
      width: _holeColWidth,
      height: _rowHeight,
      child: Center(
        child: _ScoreSymbolWidget(strokes: strokes, symbol: symbol),
      ),
    );
  }

  Widget _cell({required double width, required Widget child}) {
    return SizedBox(
      width: width,
      height: _rowHeight,
      child: Center(child: child),
    );
  }
}

class _ScoreSymbolWidget extends StatelessWidget {
  final int strokes;
  final ScoreSymbol symbol;

  const _ScoreSymbolWidget({required this.strokes, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    const size = 30.0;

    final text = Text(
      '$strokes',
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _textColor(textColor)),
    );

    switch (symbol) {
      case ScoreSymbol.par:
        return text;

      case ScoreSymbol.birdie:
        // Circle (stroke only)
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CirclePainter(
                filled: false, hasFrame: false, color: AppColors.green),
            child: Center(child: text),
          ),
        );

      case ScoreSymbol.eagle:
        // Solid circle
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CirclePainter(
                filled: true, hasFrame: false, color: AppColors.green),
            child: Center(
              child: Text(
                '$strokes',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        );

      case ScoreSymbol.albatrossOrBetter:
        // Solid circle with frame
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CirclePainter(
                filled: true, hasFrame: true, color: AppColors.green),
            child: Center(
              child: Text(
                '$strokes',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        );

      case ScoreSymbol.bogey:
        // Square (stroke only)
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _SquarePainter(
                filled: false, hasFrame: false, color: AppColors.blue),
            child: Center(child: text),
          ),
        );

      case ScoreSymbol.doubleBogey:
        // Solid square
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _SquarePainter(
                filled: true, hasFrame: false, color: AppColors.blue),
            child: Center(
              child: Text(
                '$strokes',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        );

      case ScoreSymbol.tripleBogeyOrWorse:
        // Solid square with frame
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _SquarePainter(
                filled: true, hasFrame: true, color: AppColors.blue),
            child: Center(
              child: Text(
                '$strokes',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        );
    }
  }

  Color _textColor(Color defaultColor) {
    switch (symbol) {
      case ScoreSymbol.par:
        return defaultColor;
      case ScoreSymbol.birdie:
        return AppColors.green;
      case ScoreSymbol.bogey:
        return AppColors.blue;
      case ScoreSymbol.eagle:
      case ScoreSymbol.albatrossOrBetter:
      case ScoreSymbol.doubleBogey:
      case ScoreSymbol.tripleBogeyOrWorse:
        return Colors.white;
    }
  }
}

class _CirclePainter extends CustomPainter {
  final bool filled;
  final bool hasFrame;
  final Color color;

  _CirclePainter(
      {required this.filled, required this.hasFrame, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    if (hasFrame) {
      // Outer frame circle
      final framePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, radius, framePaint);

      // Inner filled circle
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius - 3, fillPaint);
    } else if (filled) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, paint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) =>
      filled != oldDelegate.filled ||
      hasFrame != oldDelegate.hasFrame ||
      color != oldDelegate.color;
}

class _SquarePainter extends CustomPainter {
  final bool filled;
  final bool hasFrame;
  final Color color;

  _SquarePainter(
      {required this.filled, required this.hasFrame, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));

    if (hasFrame) {
      // Outer frame
      final framePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRRect(rrect, framePaint);

      // Inner filled
      final innerRect = Rect.fromLTWH(5, 5, size.width - 10, size.height - 10);
      final innerRRect =
          RRect.fromRectAndRadius(innerRect, const Radius.circular(2));
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawRRect(innerRRect, fillPaint);
    } else if (filled) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, paint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SquarePainter oldDelegate) =>
      filled != oldDelegate.filled ||
      hasFrame != oldDelegate.hasFrame ||
      color != oldDelegate.color;
}
