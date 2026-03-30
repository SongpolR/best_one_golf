import 'package:flutter/material.dart';

/// A +/− stepper that replaces numeric text fields.
///
/// When [nullable] is true the value can be null (unset), and pressing
/// the decrement button at [min] clears the value back to null.
/// When [nullable] is false the value is always clamped to [min]..[max].
class NumberStepper extends StatelessWidget {
  final int? value;
  final int min;
  final int max;
  final String label;
  final bool nullable;
  final void Function(int?) onChanged;

  /// Optional keys placed on the decrement / increment buttons for testing.
  final Key? decrementKey;
  final Key? incrementKey;

  const NumberStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
    this.nullable = false,
    this.decrementKey,
    this.incrementKey,
  });

  bool get _canDecrement {
    if (value == null) return false;
    return nullable || value! > min;
  }

  bool get _canIncrement => value == null || value! < max;

  void _decrement() {
    if (value == null) return;
    if (value! <= min && nullable) {
      onChanged(null);
    } else if (value! > min) {
      onChanged(value! - 1);
    }
  }

  void _increment() {
    if (value == null) {
      onChanged(min);
    } else if (value! < max) {
      onChanged(value! + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.35),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              _StepButton(
                key: decrementKey,
                icon: Icons.remove_rounded,
                enabled: _canDecrement,
                onTap: _decrement,
                primaryColor: colorScheme.primary,
              ),
              Expanded(
                child: Text(
                  value != null ? '$value' : '—',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: value != null
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant.withOpacity(0.35),
                  ),
                ),
              ),
              _StepButton(
                key: incrementKey,
                icon: Icons.add_rounded,
                enabled: _canIncrement,
                onTap: _increment,
                primaryColor: colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final Color primaryColor;

  const _StepButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Icon(
          icon,
          size: 20,
          color: enabled ? primaryColor : primaryColor.withOpacity(0.25),
        ),
      ),
    );
  }
}