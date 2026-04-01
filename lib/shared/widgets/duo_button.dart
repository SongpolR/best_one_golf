import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// A primary CTA button that replicates Duolingo's signature 3-D raised effect.
///
/// At rest the button casts a solid [shadowColor] offset shadow (no blur),
/// making it appear raised. On tap it shifts down 4 px and the shadow
/// disappears, simulating a physical press.
///
/// Usage — drop in anywhere you would use a full-width [FilledButton]:
/// ```dart
/// DuoButton(
///   onPressed: () { /* ... */ },
///   child: Text('Start game'),
/// )
/// ```
///
/// For destructive actions use [DuoButton.red].
class DuoButton extends StatefulWidget {
  const DuoButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.shadowColor,
    this.foregroundColor,
    this.fullWidth = true,
  });

  /// Convenience constructor for destructive actions (red palette).
  const DuoButton.red({
    super.key,
    required this.onPressed,
    required this.child,
    this.fullWidth = true,
  })  : backgroundColor = AppColors.red,
        shadowColor = AppColors.redDark,
        foregroundColor = Colors.white;

  final VoidCallback? onPressed;
  final Widget child;

  /// Button face colour. Defaults to [AppColors.green].
  final Color? backgroundColor;

  /// Solid shadow colour (the "bottom edge"). Defaults to [AppColors.greenDark].
  final Color? shadowColor;

  /// Text / icon colour. Defaults to [Colors.white].
  final Color? foregroundColor;

  /// When true the button stretches to fill the available width.
  final bool fullWidth;

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  static const _shadowHeight = 4.0;

  @override
  Widget build(BuildContext context) {
    final bg = _enabled
        ? (widget.backgroundColor ?? AppColors.green)
        : AppColors.polar;
    final shadow = _enabled
        ? (widget.shadowColor ?? AppColors.greenDark)
        : AppColors.polar;
    final fg =
        _enabled ? (widget.foregroundColor ?? Colors.white) : AppColors.cloud;

    // Reserve _shadowHeight at the bottom so the layout never shifts.
    Widget button = Padding(
      padding: const EdgeInsets.only(bottom: _shadowHeight),
      child: GestureDetector(
        onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _enabled
            ? (_) {
                setState(() => _pressed = false);
                widget.onPressed!();
              }
            : null,
        onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform:
              Matrix4.translationValues(0, _pressed ? _shadowHeight : 0, 0),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _enabled && !_pressed
                ? [
                    BoxShadow(
                      color: shadow,
                      offset: const Offset(0, _shadowHeight),
                      blurRadius: 0,
                    ),
                  ]
                : const [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
                color: fg,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                decoration: TextDecoration.none,
              ),
              child: IconTheme(
                data: IconThemeData(color: fg, size: 20),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
