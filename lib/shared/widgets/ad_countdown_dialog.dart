import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Shows a modal dialog with a countdown timer when an ad cannot be loaded.
/// Automatically closes after [seconds] and the caller can continue
/// navigation normally.
Future<void> showAdCountdownDialog(
  BuildContext context, {
  int seconds = 5,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AdCountdownDialog(seconds: seconds),
  );
}

class _AdCountdownDialog extends StatefulWidget {
  const _AdCountdownDialog({required this.seconds});

  final int seconds;

  @override
  State<_AdCountdownDialog> createState() => _AdCountdownDialogState();
}

class _AdCountdownDialogState extends State<_AdCountdownDialog> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        if (mounted) Navigator.of(context).pop();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: _remaining / widget.seconds,
                  strokeWidth: 5,
                  color: AppColors.green,
                  backgroundColor: cs.outlineVariant,
                ),
              ),
              Text(
                '$_remaining',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.green,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l10n.adNotAvailable,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.adContinuingIn(_remaining),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
