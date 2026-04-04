import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Particle model (confetti)
// ─────────────────────────────────────────────────────────────────────────────
class _Particle {
  final double angle; // radians; upper-hemisphere burst
  final double speed; // 0..1
  final Color color;
  final double size; // px

  const _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;

  // Total animation length ≤ 3 s for good UX.
  static const _kDuration = Duration(milliseconds: 3600);

  @override
  void initState() {
    super.initState();
    _particles = _buildParticles(52);
    _ctrl = AnimationController(vsync: this, duration: _kDuration)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) context.go('/');
      });
    // Let the first frame render before the animation begins.
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static List<_Particle> _buildParticles(int count) {
    final rng = Random(42);
    const palette = <Color>[
      Color(0xFF58AA02), // brand green
      Color(0xFFFFC800), // yellow
      Color(0xFF1CB0F6), // blue
      Color(0xFFFF4B4B), // red
      Color(0xFFFF9800), // orange
      Color(0xFFD7F5C0), // light green
      Color(0xFFFFFFFF), // white
    ];
    return List.generate(count, (i) {
      // Full upper semicircle: -π … 0  (y grows downward → negative = up)
      final angle = -pi * (0.05 + rng.nextDouble() * 0.90);
      return _Particle(
        angle: angle,
        speed: 0.28 + rng.nextDouble() * 0.72,
        color: palette[i % palette.length],
        size: 4.0 + rng.nextDouble() * 5.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Matches the sky gradient top colour so there is no flash on start.
      backgroundColor: const Color(0xFFF0F8F2),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, _) => _buildContent(ctx, _ctrl.value),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double t) {
    return Stack(
      children: [
        // ── Full-screen animation ──────────────────────────────────────
        Positioned.fill(
          child: CustomPaint(
            painter: _GolfPainter(t: t, particles: _particles),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Math helpers
// ─────────────────────────────────────────────────────────────────────────────
double _norm(double t, double a, double b) =>
    ((t - a) / (b - a)).clamp(0.0, 1.0);

double _clamp(double v) => v.clamp(0.0, 1.0);

// Decelerate to rest.
double _easeOut(double t) => 1.0 - pow(1.0 - t, 2.5).toDouble();

// Accelerate from rest.
double _easeIn(double t) => pow(t, 2.2).toDouble();

// ─────────────────────────────────────────────────────────────────────────────
// Painter
// ─────────────────────────────────────────────────────────────────────────────
class _GolfPainter extends CustomPainter {
  final double t;
  final List<_Particle> particles;

  _GolfPainter({required this.t, required this.particles});

  // ── Animation timeline (t: 0.0 → 1.0 over 3 600 ms) ───────────────────
  static const _tImpact = 0.00; // club contacts ball
  static const _tRollEnd = 0.48; // ball reaches hole
  static const _tDropEnd = 0.74; // ball inside hole
  static const _tFlagPeak = 0.86; // flag fully raised
  static const _tEnd = 1.00;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Scene geometry ─────────────────────────────────────────────────
    final groundY = h * 0.74; // ground line – leaves room below for the name
    final ballR = w * 0.056; // ball radius
    final ballStartX = w * -0.5; // ball starts on the left
    final holeX = w * 0.5; // hole on the right
    final holeRx = w * 0.092; // hole ellipse x-radius
    final holeRy = holeRx * 0.41; // hole ellipse y-radius

    // Draw back-to-front
    _drawBackground(canvas, w, h, groundY);
    _drawHole(canvas, holeX, groundY, holeRx, holeRy);
    _drawConfetti(canvas, w, h, holeX, groundY);
    _drawFlag(canvas, w, h, holeX, groundY);
    _drawBall(canvas, ballStartX, holeX, groundY, ballR);
  }

  // ── Background & fairway ───────────────────────────────────────────────
  void _drawBackground(Canvas canvas, double w, double h, double groundY) {
    // Sky
    final skyRect = Rect.fromLTWH(0, 0, w, groundY);
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEAF6F0), Color(0xFFF0F8F2)],
        ).createShader(skyRect),
    );

    // Fairway
    final greenRect = Rect.fromLTWH(0, groundY, w, h - groundY);
    canvas.drawRect(
      greenRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5CB83F), Color(0xFF3C8827)],
        ).createShader(greenRect),
    );

    // Fringe line
    canvas.drawLine(
      Offset(0, groundY),
      Offset(w, groundY),
      Paint()
        ..color = const Color(0xFF72C94C)
        ..strokeWidth = 2.0,
    );

    // Subtle mowing stripes
    final stripe = Paint()..color = Colors.black.withOpacity(0.022);
    const n = 7;
    for (int i = 0; i < n; i++) {
      final x = i * w / n;
      canvas.drawRect(
        Rect.fromLTWH(x, groundY, w / (n * 2), h - groundY),
        stripe,
      );
    }
  }

  // ── Hole ──────────────────────────────────────────────────────────────
  void _drawHole(
      Canvas canvas, double holeX, double groundY, double rx, double ry) {
    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(holeX, groundY + ry * 0.65),
        width: rx * 2.6,
        height: ry * 1.9,
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    // Cup
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(holeX, groundY), width: rx * 2, height: ry * 2),
      Paint()..color = const Color(0xFF0B0B0B),
    );
  }

  // ── Ball ──────────────────────────────────────────────────────────────
  void _drawBall(
    Canvas canvas,
    double startX,
    double holeX,
    double groundY,
    double ballR,
  ) {
    double bx, by, scale;

    if (t < _tImpact) {
      bx = startX;
      by = groundY - ballR;
      scale = 1.0;
    } else if (t < _tRollEnd) {
      final p = _easeOut(_norm(t, _tImpact, _tRollEnd));
      bx = startX + (holeX - startX) * p;
      by = groundY - ballR;
      scale = 1.0;
    } else if (t < _tDropEnd) {
      final p = _norm(t, _tRollEnd, _tDropEnd);
      bx = holeX;
      by = groundY - ballR + _easeIn(p) * ballR * 3.0;
      scale = 1.0 - _easeIn(p);
    } else {
      return;
    }

    if (scale < 0.02) return;

    // Ground shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bx, groundY + 1),
        width: ballR * 2.7 * scale,
        height: ballR * 0.52 * scale,
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.20 * scale)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Ball body (radial gradient for 3-D look)
    final center = Offset(bx, by);
    final r = ballR * scale;
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.45),
          radius: 0.85,
          colors: [Colors.white, Color(0xFFD5D5D5)],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    // Rotation angle: rolling without slipping (distance / radius), clockwise.
    double rotation = 0.0;
    if (t >= _tImpact && t < _tRollEnd) {
      rotation = (bx - startX) / ballR;
    } else if (t >= _tRollEnd) {
      rotation = (holeX - startX) / ballR;
    }

    // Dimples (hex grid, clipped to ball circle, rotated with the ball).
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: r)));
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    _drawDimples(canvas, r, scale);
    canvas.restore();

    // Outline
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = const Color(0xFFBBBBBB).withOpacity(scale)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  // ── Ball dimples ───────────────────────────────────────────────────────────
  // Draws dimples relative to the current canvas origin (call after translate +
  // rotate so the pattern spins with the ball).
  void _drawDimples(Canvas canvas, double r, double scale) {
    final dimpleR = r * 0.07;
    final spacing = r * 0.40;
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC).withOpacity(scale);

    for (int row = -5; row <= 5; row++) {
      final dy = row * spacing;
      final xOff = (row.abs() % 2 == 1) ? spacing * 0.5 : 0.0;
      for (int col = -5; col <= 5; col++) {
        final dx = col * spacing + xOff;
        if (dx * dx + dy * dy > (r - dimpleR) * (r - dimpleR)) continue;
        canvas.drawCircle(Offset(dx, dy), dimpleR, paint);
      }
    }
  }

  // ── Flag ──────────────────────────────────────────────────────────────
  void _drawFlag(
      Canvas canvas, double w, double h, double holeX, double groundY) {
    if (t <= _tDropEnd) return;

    final riseT = _easeOut(_norm(t, _tDropEnd, _tDropEnd + 0.09));
    final flagT = _easeOut(_norm(t, _tDropEnd + 0.07, _tFlagPeak));
    // Pole height: 52 % of full-screen height → visibly tall
    final poleH = h * 0.52 * riseT;

    // Pole
    canvas.drawLine(
      Offset(holeX, groundY),
      Offset(holeX, groundY - poleH),
      Paint()
        ..color = const Color(0xFFCCCCCC)
        ..strokeWidth = 8.2
        ..strokeCap = StrokeCap.round,
    );

    if (flagT <= 0) return;

    final fTopY = groundY - poleH;
    // Flag body: wider and taller than previous versions
    final fW = w * 0.38 * flagT;
    final fH = h * 0.11 * flagT;

    // Flag body (rectangle)
    final flagRect = Rect.fromLTWH(holeX, fTopY, fW, fH);
    canvas.drawRect(flagRect, Paint()..color = const Color(0xFFFF4B4B));
    canvas.drawRect(
      flagRect,
      Paint()
        ..color = const Color(0xFFFF7070)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // "1" number on flag
    if (flagT > 0.50) {
      final numOpacity = _clamp(_norm(flagT, 0.50, 1.0));
      final tp = TextPainter(
        text: TextSpan(
          text: 'BestOne',
          style: TextStyle(
            color: Colors.white.withOpacity(numOpacity),
            fontSize: fH * 0.24,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      // Centre the "1" within the rectangle.
      tp.paint(
        canvas,
        Offset(
          holeX + (fW - tp.width) / 2,
          fTopY + (fH - tp.height) / 2,
        ),
      );
    }
  }

  // ── Confetti ──────────────────────────────────────────────────────────
  void _drawConfetti(
      Canvas canvas, double w, double h, double holeX, double groundY) {
    if (t < _tDropEnd + 0.01) return;

    final ct = _norm(t, _tDropEnd + 0.01, _tEnd);

    for (final p in particles) {
      final trav = _easeOut(ct) * p.speed;
      final px = holeX + cos(p.angle) * trav * w * 0.65;
      final py = groundY +
          sin(p.angle) * trav * h * 0.55 +
          ct * ct * h * 0.30; // gravity

      final opacity = (1.0 - ct * 1.25).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(ct * p.speed * pi * 4.5); // tumble
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: p.size, height: p.size * 0.42),
        Paint()..color = p.color.withOpacity(opacity),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_GolfPainter old) => old.t != t;
}
