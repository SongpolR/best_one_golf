import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../core/utils/currency_formatter.dart';

enum HoleResultViewMode {
  summary,
  detail,
}

class HoleResultSheet extends ConsumerStatefulWidget {
  final String gameId;
  final int holeNumber;

  const HoleResultSheet({
    super.key,
    required this.gameId,
    required this.holeNumber,
  });

  @override
  ConsumerState<HoleResultSheet> createState() => _HoleResultSheetState();
}

class _HoleResultSheetState extends ConsumerState<HoleResultSheet> {
  HoleResultViewMode mode = HoleResultViewMode.summary;

  @override
  Widget build(BuildContext context) {
    final resultAsync = ref.watch(
      holeResultProvider(
        (gameId: widget.gameId, holeNumber: widget.holeNumber),
      ),
    );
    final settingsAsync = ref.watch(appSettingsProvider);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: settingsAsync.when(
          data: (settings) {
            return resultAsync.when(
              data: (result) {
                if (result == null) {
                  return const _SheetFrame(
                    title: 'Hole Result',
                    child: Center(
                      child: Text('No result available yet.'),
                    ),
                  );
                }

                return _SheetFrame(
                  title: 'Hole ${result.holeNumber} Result',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopMeta(
                        isComplete: result.isComplete,
                        isTurbo: result.isTurbo,
                        isBirdieBonus: result.isBirdieBonus,
                        baseAmount: result.baseAmount == null
                            ? null
                            : CurrencyFormatter.format(
                                result.baseAmount!,
                                settings.currency,
                              ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<HoleResultViewMode>(
                        segments: const [
                          ButtonSegment(
                            value: HoleResultViewMode.summary,
                            label: Text('Summary'),
                          ),
                          ButtonSegment(
                            value: HoleResultViewMode.detail,
                            label: Text('Detail'),
                          ),
                        ],
                        selected: {mode},
                        onSelectionChanged: (selection) {
                          setState(() {
                            mode = selection.first;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: mode == HoleResultViewMode.summary
                            ? _SummaryView(
                                playerNet: result.playerNet,
                                teamNet: result.teamNet,
                                formatter: (amount) =>
                                    CurrencyFormatter.formatSigned(
                                  amount,
                                  settings.currency,
                                ),
                              )
                            : _DetailView(
                                playerMovements: result.playerMovements
                                    .map(
                                      (move) => _MovementTileData(
                                        title: '${move.fromId} → ${move.toId}',
                                        subtitle: '${move.rule} • ${move.note}',
                                        amount: CurrencyFormatter.format(
                                          move.amount,
                                          settings.currency,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                teamMovements: result.teamMovements
                                    .map(
                                      (move) => _MovementTileData(
                                        title:
                                            '${move.fromTeamId} → ${move.toTeamId}',
                                        subtitle: '${move.rule} • ${move.note}',
                                        amount: CurrencyFormatter.format(
                                          move.amount,
                                          settings.currency,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const _SheetFrame(
                title: 'Hole Result',
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => _SheetFrame(
                title: 'Hole Result',
                child: Center(
                  child: Text('Failed to load hole result: $error'),
                ),
              ),
            );
          },
          loading: () => const _SheetFrame(
            title: 'Hole Result',
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => _SheetFrame(
            title: 'Hole Result',
            child: Center(
              child: Text('Failed to load app settings: $error'),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  final String title;
  final Widget child;

  const _SheetFrame({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Expanded(child: child),
      ],
    );
  }
}

class _TopMeta extends StatelessWidget {
  final bool isComplete;
  final bool isTurbo;
  final bool isBirdieBonus;
  final String? baseAmount;

  const _TopMeta({
    required this.isComplete,
    required this.isTurbo,
    required this.isBirdieBonus,
    required this.baseAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _MetaChip(label: isComplete ? 'Complete' : 'Incomplete'),
        _MetaChip(label: isTurbo ? 'Turbo ON' : 'Turbo OFF'),
        _MetaChip(label: isBirdieBonus ? 'Birdie ON' : 'Birdie OFF'),
        if (baseAmount != null) _MetaChip(label: 'Base $baseAmount'),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _SummaryView extends StatelessWidget {
  final Map<String, int> playerNet;
  final Map<String, int> teamNet;
  final String Function(int amount) formatter;

  const _SummaryView({
    required this.playerNet,
    required this.teamNet,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final hasTeam = teamNet.isNotEmpty;
    final hasPlayer = playerNet.isNotEmpty;

    return ListView(
      children: [
        if (!hasPlayer && !hasTeam) const Text('No net result yet.'),
        if (hasTeam) ...[
          Text(
            'Team Net',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...teamNet.entries.map(
            (entry) => Card(
              child: ListTile(
                title: Text(entry.key),
                trailing: Text(formatter(entry.value)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (hasPlayer) ...[
          Text(
            'Player Net',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...playerNet.entries.map(
            (entry) => Card(
              child: ListTile(
                title: Text(entry.key),
                trailing: Text(formatter(entry.value)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailView extends StatelessWidget {
  final List<_MovementTileData> playerMovements;
  final List<_MovementTileData> teamMovements;

  const _DetailView({
    required this.playerMovements,
    required this.teamMovements,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Player Movements',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (playerMovements.isEmpty)
          const Text('No player movements.')
        else
          ...playerMovements.map(
            (move) => Card(
              child: ListTile(
                title: Text(move.title),
                subtitle: Text(move.subtitle),
                trailing: Text(move.amount),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Team Movements',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (teamMovements.isEmpty)
          const Text('No team movements.')
        else
          ...teamMovements.map(
            (move) => Card(
              child: ListTile(
                title: Text(move.title),
                subtitle: Text(move.subtitle),
                trailing: Text(move.amount),
              ),
            ),
          ),
      ],
    );
  }
}

class _MovementTileData {
  final String title;
  final String subtitle;
  final String amount;

  const _MovementTileData({
    required this.title,
    required this.subtitle,
    required this.amount,
  });
}
