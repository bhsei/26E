import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Full-screen wave artwork used on the dark DēGlitch splash screen.
class AnimatedWaveBackground extends StatefulWidget {
  const AnimatedWaveBackground({super.key});

  @override
  State<AnimatedWaveBackground> createState() => _AnimatedWaveBackgroundState();
}

class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _WavePainter(_controller.value),
        size: Size.infinite,
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.phase);
  final double phase;

  Path _wave(Size size, double base, double amplitude, double offset) {
    final path = Path()..moveTo(0, base);
    for (double x = 0; x <= size.width + 4; x += 4) {
      final y =
          base +
          math.sin((x / size.width * math.pi * 2) + offset) * amplitude +
          math.sin((x / size.width * math.pi * 4) - offset * 0.72) *
              amplitude *
              0.22;
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final base = size.height * 0.72;
    final t = phase * math.pi * 2;
    canvas.drawPath(
      _wave(size, base + 7, size.height * 0.045, t + 0.9),
      Paint()..color = const Color(0xFF0878F9).withValues(alpha: 0.18),
    );
    canvas.drawPath(
      _wave(size, base + 31, size.height * 0.052, t + 2.1),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF075BBF), Color(0xFF012653)],
        ).createShader(Rect.fromLTWH(0, base, size.width, size.height - base)),
    );
    canvas.drawPath(
      _wave(size, base + 62, size.height * 0.035, t + 3.3),
      Paint()..color = const Color(0xFF0878F9).withValues(alpha: 0.42),
    );

    // Bright current line rides the upper wave. It drifts in a slow loop.
    final line = Path();
    for (double x = 0; x <= size.width + 4; x += 4) {
      final y =
          base -
          9 +
          math.sin((x / size.width * math.pi * 2) + t) * size.height * 0.045;
      if (x == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = const Color(0xFF20D5FF).withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.phase != phase;
}
