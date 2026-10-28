import 'dart:math' as math;

import 'package:flutter/material.dart';

const Color deglitchNavy = Color(0xFF082D68);
const Color deglitchBlue = Color(0xFF0878F9);
const Color deglitchCyan = Color(0xFF23D5FF);
const Color deglitchPale = Color(0xFFF4FAFF);

/// Vector-rendered DēGlitch mark. It does not require a new image asset and
/// follows the D + lightning + speed-lines motif from the supplied reference.
class DeglitchMark extends StatelessWidget {
  const DeglitchMark({
    super.key,
    this.size = 88,
    this.phase = 0,
    this.darkBackground = false,
  });

  final double size;
  final double phase;
  final bool darkBackground;

  @override
  Widget build(BuildContext context) {
    final primary = darkBackground ? Colors.white : deglitchBlue;
    return SizedBox(
      width: size * 1.18,
      height: size,
      child: CustomPaint(
        painter: _DeglitchMarkPainter(
          phase: phase,
          primary: primary,
          cyan: deglitchCyan,
          darkBackground: darkBackground,
        ),
      ),
    );
  }
}

class _DeglitchMarkPainter extends CustomPainter {
  const _DeglitchMarkPainter({
    required this.phase,
    required this.primary,
    required this.cyan,
    required this.darkBackground,
  });

  final double phase;
  final Color primary;
  final Color cyan;
  final bool darkBackground;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(w * 0.25, h * 0.06, w * 0.69, h * 0.86);
    final glow = Paint()
      ..color = cyan.withValues(
        alpha: 0.15 + 0.12 * (0.5 + 0.5 * math.sin(phase * math.pi * 2)),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi,
      false,
      glow
        ..style = PaintingStyle.stroke
        ..strokeWidth = h * 0.15
        ..strokeCap = StrokeCap.round,
    );

    final dPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: darkBackground
            ? [
                const Color(0xFF68F0FF),
                const Color(0xFF19A9FF),
                const Color(0xFF437EFF),
              ]
            : [
                const Color(0xFF21CFFF),
                const Color(0xFF0878F9),
                const Color(0xFF123CBE),
              ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.115
      ..strokeCap = StrokeCap.round;

    // Open D-shaped arc, inspired by the supplied logo.
    canvas.drawArc(rect, -math.pi * 0.46, math.pi * 0.92, false, dPaint);
    canvas.drawLine(
      Offset(w * 0.56, h * 0.08),
      Offset(w * 0.56, h * 0.92),
      dPaint,
    );

    // Three fast-moving lines entering the D.
    final streakPaint = Paint()
      ..color = primary
      ..strokeWidth = h * 0.045
      ..strokeCap = StrokeCap.round;
    final streakShift = math.sin(phase * math.pi * 2) * w * 0.025;
    canvas.drawLine(
      Offset(w * 0.03 + streakShift, h * 0.36),
      Offset(w * 0.34, h * 0.36),
      streakPaint,
    );
    canvas.drawLine(
      Offset(w * 0.00 - streakShift, h * 0.49),
      Offset(w * 0.29, h * 0.49),
      streakPaint,
    );
    canvas.drawLine(
      Offset(w * 0.08 + streakShift, h * 0.62),
      Offset(w * 0.35, h * 0.62),
      streakPaint,
    );

    // Lightning bolt / current running through the centre.
    final bolt = Path()
      ..moveTo(w * 0.58, h * 0.19)
      ..lineTo(w * 0.43, h * 0.50)
      ..lineTo(w * 0.56, h * 0.50)
      ..lineTo(w * 0.45, h * 0.82)
      ..lineTo(w * 0.73, h * 0.43)
      ..lineTo(w * 0.60, h * 0.43)
      ..close();
    final boltPaint = Paint()
      ..color = darkBackground
          ? const Color(0xFFECFEFF)
          : const Color(0xFFF8FDFF)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bolt, boltPaint);

    // A short travelling current highlight on the outer stroke.
    final currentAngle = -math.pi * 0.46 + ((phase % 1) * math.pi * 0.92);
    final currentPoint = Offset(
      rect.center.dx + rect.width / 2 * math.cos(currentAngle),
      rect.center.dy + rect.height / 2 * math.sin(currentAngle),
    );
    final currentPaint = Paint()
      ..color = cyan
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(currentPoint, h * 0.045, currentPaint);
    canvas.drawCircle(currentPoint, h * 0.018, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _DeglitchMarkPainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.primary != primary ||
      oldDelegate.cyan != cyan ||
      oldDelegate.darkBackground != darkBackground;
}

/// Animated logo and wordmark. Tiny cyan/blue offsets create a brief, controlled
/// glitch pulse while the logo highlight travels across the mark.
class GlitchBrand extends StatefulWidget {
  const GlitchBrand({
    super.key,
    this.iconSize = 84,
    this.showWordmark = true,
    this.darkBackground = false,
    this.animated = true,
    this.tagline,
  });

  final double iconSize;
  final bool showWordmark;
  final bool darkBackground;
  final bool animated;
  final String? tagline;

  @override
  State<GlitchBrand> createState() => _GlitchBrandState();
}

class _GlitchBrandState extends State<GlitchBrand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2300),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animated) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant GlitchBrand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animated && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = widget.darkBackground ? Colors.white : deglitchNavy;
    final accentColor = widget.darkBackground ? deglitchCyan : deglitchBlue;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = widget.animated ? _controller.value : 0.0;
        final glitch =
            widget.animated &&
            ((t > 0.315 && t < 0.36) || (t > 0.785 && t < 0.812));
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (glitch)
                  Transform.translate(
                    offset: const Offset(3, 0),
                    child: Opacity(
                      opacity: 0.55,
                      child: DeglitchMark(
                        size: widget.iconSize,
                        phase: t,
                        darkBackground: widget.darkBackground,
                      ),
                    ),
                  ),
                if (glitch)
                  Transform.translate(
                    offset: const Offset(-3, 1),
                    child: Opacity(
                      opacity: 0.46,
                      child: CustomPaint(
                        size: Size(widget.iconSize * 1.18, widget.iconSize),
                        painter: _DeglitchMarkPainter(
                          phase: t + 0.4,
                          primary: const Color(0xFF4AE8FF),
                          cyan: const Color(0xFF4AE8FF),
                          darkBackground: widget.darkBackground,
                        ),
                      ),
                    ),
                  ),
                DeglitchMark(
                  size: widget.iconSize,
                  phase: t,
                  darkBackground: widget.darkBackground,
                ),
              ],
            ),
            if (widget.showWordmark) ...[
              const SizedBox(height: 5),
              Stack(
                alignment: Alignment.center,
                children: [
                  if (glitch)
                    Transform.translate(
                      offset: const Offset(2.5, -0.5),
                      child: Opacity(
                        opacity: 0.7,
                        child: _Wordmark(
                          color: deglitchCyan,
                          size: widget.iconSize * 0.37,
                        ),
                      ),
                    ),
                  if (glitch)
                    Transform.translate(
                      offset: const Offset(-2.5, 0.5),
                      child: Opacity(
                        opacity: 0.55,
                        child: _Wordmark(
                          color: const Color(0xFF4C94FF),
                          size: widget.iconSize * 0.37,
                        ),
                      ),
                    ),
                  _Wordmark(
                    color: mainColor,
                    accent: accentColor,
                    size: widget.iconSize * 0.37,
                  ),
                ],
              ),
              if (widget.tagline != null) ...[
                const SizedBox(height: 13),
                Text(
                  widget.tagline!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.darkBackground
                        ? const Color(0xFFD7F3FF)
                        : const Color(0xFF24548C),
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.color, this.accent, required this.size});
  final Color color;
  final Color? accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
        children: [
          TextSpan(
            text: 'Dē',
            style: TextStyle(color: color),
          ),
          TextSpan(
            text: 'Glitch',
            style: TextStyle(color: accent ?? color),
          ),
        ],
      ),
    );
  }
}
