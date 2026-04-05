// tool/generate_icon.dart
//
// Generates the BestOneGolf app-icon assets using the `image` package
// (pure Dart – no Flutter runtime required).
//
// Run from the project root:
//   dart run tool/generate_icon.dart
//
// Outputs:
//   assets/icon/app_icon.png      — 1024×1024, opaque bg   (iOS + Android legacy)
//   assets/icon/app_icon_fg.png   — 1024×1024, transparent bg (Android adaptive fg)
//
// Then apply with:
//   dart run flutter_launcher_icons

import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

// ── Canvas ───────────────────────────────────────────────────────────────────
const _sz = 1024;
const _cx = _sz ~/ 2; // 512 – horizontal centre
const _cy = _sz ~/ 2; // 512 – vertical centre

// ── Colours ───────────────────────────────────────────────────────────────────
final _bgGreen = img.ColorRgba8(88, 204, 2, 255); // #58CC02 – brand green bg
final _ball = img.ColorRgba8(252, 252, 252, 255); // near-white ball body
final _dimple = img.ColorRgba8(215, 215, 215, 255); // light-grey dimples
final _oneColor = img.ColorRgba8(26, 92, 10, 255); // #1A5C0A – dark green "1"

// ── Ball geometry ─────────────────────────────────────────────────────────────
const _ballR =
    430; // ball radius (86 % of half-canvas → leaves visible bg border)

// ── "1" geometry (all values validated to stay within the ball circle) ────────
//
//  Vertical bar: centred at x = _cx, spans y 290→730, stroke-width 88 px
//    → half-width = 44 px, so bar occupies x 468..556
//    At y=290: √((0)²+(290-512)²) = 222 < 430 ✓
//    At y=730: √((0)²+(730-512)²) = 218 < 430 ✓
//
//  Top-left serif: from (430, 380) to (_cx, 290), stroke-width 68 px
//    (430,380): √((430-512)²+(380-512)²) ≈ 154 < 430 ✓
//
const _barTop = 290;
const _barBot = 730;
const _barTk = 88; // vertical bar stroke width
const _sX1 = 430; // serif anchor x
const _sY1 = 380; // serif anchor y
const _sTk = 68; // serif stroke width

// ── Dimple grid ───────────────────────────────────────────────────────────────
const _dimpleR = 22; // dimple radius
const _dimpleSpc = 108; // hex-grid row / column spacing
// Exclusion band: skip dimples that would sit under the "1" stroke
const _exHalfW = 64; // half-width of exclusion band (|Δx| < this)
const _exHalfH = 255; // half-height of exclusion band (|Δy| < this)

// ─────────────────────────────────────────────────────────────────────────────
void main() async {
  await Directory('assets/icon').create(recursive: true);

  final full = _render(withBg: true);
  await File('assets/icon/app_icon.png').writeAsBytes(img.encodePng(full));
  stdout.writeln('✓  assets/icon/app_icon.png');

  final fg = _render(withBg: false);
  await File('assets/icon/app_icon_fg.png').writeAsBytes(img.encodePng(fg));
  stdout.writeln('✓  assets/icon/app_icon_fg.png');

  stdout.writeln('\nNow run:  dart run flutter_launcher_icons');
}

// ─────────────────────────────────────────────────────────────────────────────
img.Image _render({required bool withBg}) {
  final icon = img.Image(width: _sz, height: _sz);

  // ── Background ─────────────────────────────────────────────────────────────
  if (withBg) img.fill(icon, color: _bgGreen);

  // ── Golf ball (white circle) ────────────────────────────────────────────────
  img.fillCircle(
    icon,
    x: _cx,
    y: _cy,
    radius: _ballR,
    color: _ball,
    antialias: true,
  );

  // ── Dimples (hex grid, skipping the "1" zone) ──────────────────────────────
  _drawDimples(icon);

  // ── "1" digit ──────────────────────────────────────────────────────────────
  // Vertical bar
  img.drawLine(
    icon,
    x1: _cx,
    y1: _barTop,
    x2: _cx,
    y2: _barBot,
    color: _oneColor,
    thickness: _barTk,
    antialias: false,
  );
  // Top-left diagonal serif / hook
  img.drawLine(
    icon,
    x1: _sX1,
    y1: _sY1,
    x2: _cx,
    y2: _barTop,
    color: _oneColor,
    thickness: _sTk,
    antialias: true,
  );

  return icon;
}

// ─────────────────────────────────────────────────────────────────────────────
void _drawDimples(img.Image icon) {
  // Safe radius: dimple must fit entirely within the ball
  const safeDist = _ballR - _dimpleR - 6;

  for (int row = -5; row <= 5; row++) {
    final ry = row * _dimpleSpc;

    // Hex offset: alternate rows shift by half a column spacing
    final xOff = (row.abs() % 2 == 1) ? _dimpleSpc ~/ 2 : 0;

    for (int col = -5; col <= 5; col++) {
      final rx = col * _dimpleSpc + xOff;

      // Discard dimples outside the ball
      if (sqrt(rx * rx + ry * ry) > safeDist) continue;

      // Discard dimples that would overlap the "1" stroke
      if (rx.abs() < _exHalfW && ry.abs() < _exHalfH) continue;

      img.fillCircle(
        icon,
        x: _cx + rx,
        y: _cy + ry,
        radius: _dimpleR,
        color: _dimple,
        antialias: true,
      );
    }
  }
}
