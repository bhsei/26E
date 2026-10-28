import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/deglitch_brand.dart';
import '../mobile_auth/auth_copy.dart';

class MobileOnboardingScreen extends StatefulWidget {
  const MobileOnboardingScreen({super.key});

  @override
  State<MobileOnboardingScreen> createState() => _MobileOnboardingScreenState();
}

class _MobileOnboardingScreenState extends State<MobileOnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;
  bool _saving = false;

  Future<void> _finishOnboarding() async {
    if (_saving) return;
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('deglitch_onboarding_complete', true);
    if (!mounted) return;
    context.go('/mobile-sign-in');
  }

  void _nextPage() {
    if (_page < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_page > 0 && !_saving) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      authText(context, 'intro1Title'),
      authText(context, 'intro2Title'),
      authText(context, 'intro3Title'),
    ];
    final bodies = [
      authText(context, 'intro1Body'),
      authText(context, 'intro2Body'),
      authText(context, 'intro3Body'),
    ];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5FAFF),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEAF7FF), Color(0xFFFFFFFF), Color(0xFFF5FAFF)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 20, 0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/logo.png",
                            width: 35,
                            height: 30,
                            fit: BoxFit.fill,
                          ),
                          Gap(2),
                          Image.asset(
                            "assets/images/logo_name.png",
                            width: 90,
                            height: 30,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: Text(
                          authText(context, 'skip'),
                          style: const TextStyle(
                            color: deglitchBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (value) => setState(() => _page = value),
                    children: [
                      _OnboardingPage(
                        title: titles[0],
                        body: bodies[0],
                        illustration: const AnimatedGlobeIllustration(),
                      ),
                      _OnboardingPage(
                        title: titles[1],
                        body: bodies[1],
                        illustration: const SecurityIllustration(),
                      ),
                      _OnboardingPage(
                        title: titles[2],
                        body: bodies[2],
                        illustration: const NetworkIllustration(),
                      ),
                    ],
                  ),
                ),
Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 22),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final selected = index == _page;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: selected ? 23 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: selected
                                  ? deglitchBlue
                                  : const Color(0xFFC9E1F8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 21),
                      Row(
                        children: [
                          Container(
                            width: 54,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _page == 0
                                  ? const Color(0xFFEAF2F8)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(17),
                              border: Border.all(
                                color: const Color(0xFFD9EAF9),
                              ),
                              boxShadow: _page == 0
                                  ? const []
                                  : [
                                      BoxShadow(
                                        color: deglitchBlue.withValues(alpha: 0.08),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: IconButton(
                              tooltip: MaterialLocalizations.of(context)
                                  .backButtonTooltip,
                              onPressed: _page == 0 || _saving
                                  ? null
                                  : _previousPage,
                              icon: const Icon(Icons.arrow_back_rounded),
                              color: deglitchBlue,
                              disabledColor: const Color(0xFFA9BED2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF168BFF),
                                      Color(0xFF0866E9),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: deglitchBlue.withValues(alpha: 0.18),
                                      blurRadius: 17,
                                      offset: const Offset(0, 7),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _saving ? null : _nextPage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    disabledBackgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                  ),
                                  child: _saving
                                      ? const SizedBox(
                                          width: 21,
                                          height: 21,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              authText(
                                                context,
                                                _page == 2 ? 'getStarted' : 'next',
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(width: 9),
                                            Icon(
                                              _page == 2
                                                  ? Icons.check_rounded
                                                  : Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.illustration,
  });
  final String title;
  final String body;
  final Widget illustration;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(25, 24, 25, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: deglitchNavy,
            fontSize: 27,
            height: 1.18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.75,
          ),
        ),
        const SizedBox(height: 13),
        Text(
          body,
          style: const TextStyle(
            color: Color(0xFF5D7FA3),
            fontSize: 14,
            height: 1.58,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(child: Center(child: illustration)),
      ],
    ),
  );
}

class AnimatedGlobeIllustration extends StatefulWidget {
  const AnimatedGlobeIllustration({super.key});

  @override
  State<AnimatedGlobeIllustration> createState() =>
      _AnimatedGlobeIllustrationState();
}

class _AnimatedGlobeIllustrationState extends State<AnimatedGlobeIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  )..repeat();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => SizedBox(
      width: 310,
      height: 300,
      child: CustomPaint(painter: _GlobePainter(_controller.value)),
    ),
  );
}

class _GlobePainter extends CustomPainter {
  _GlobePainter(this.phase);

  final double phase;

  static const double _orbitTilt = -0.30;

  Offset _orbitPosition(
    Offset center,
    double orbitRadiusX,
    double orbitRadiusY,
    double angle,
  ) {
    final x = math.cos(angle) * orbitRadiusX;
    final y = math.sin(angle) * orbitRadiusY;
    final cosTilt = math.cos(_orbitTilt);
    final sinTilt = math.sin(_orbitTilt);
    return center + Offset(
      x * cosTilt - y * sinTilt,
      x * sinTilt + y * cosTilt,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.50);
    final radius = math.min(size.width * 0.315, size.height * 0.335).toDouble();
    final t = phase * math.pi * 2;
    final orbitRadiusX = radius * 1.38;
    final orbitRadiusY = radius * 0.79;
    final orbitRect = Rect.fromCenter(
      center: Offset.zero,
      width: orbitRadiusX * 2,
      height: orbitRadiusY * 2,
    );
    final angles = List<double>.generate(
      5,
      (index) => t * 0.34 + index * math.pi * 2 / 5,
    );

    // Soft ground glow under the globe.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.94),
        width: radius * 1.95,
        height: radius * 0.28,
      ),
      Paint()
        ..color = const Color(0xFF69BCFF).withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // The complete orbit is behind the planet; the lower/front arc is redrawn
    // after the planet so the satellite path reads as a 3D orbit.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_orbitTilt);
    canvas.drawOval(
      orbitRect,
      Paint()
        ..color = const Color(0xFF25AFFF).withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.7,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: orbitRadiusX * 2.15,
        height: orbitRadiusY * 1.70,
      ),
      Paint()
        ..color = const Color(0xFF6CCBFF).withValues(alpha: 0.16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.restore();

    // Satellites on the upper half are painted first so the globe passes
    // naturally in front of them.
    for (int i = 0; i < angles.length; i++) {
      if (math.sin(angles[i]) < 0) {
        _drawSatellite(
          canvas,
          _orbitPosition(center, orbitRadiusX, orbitRadiusY, angles[i]),
          isShield: i == 0,
          size: i == 0 ? 50 : 43,
        );
      }
    }

    final sphereRect = Rect.fromCircle(center: center, radius: radius);
    final sphere = Path()..addOval(sphereRect);

    // Richer lighting gives the planet a spherical rather than flat-ball look.
    canvas.drawPath(
      sphere,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.40, -0.48),
          radius: 1.18,
          colors: [
            Color(0xFFD5F7FF),
            Color(0xFF8DDEFF),
            Color(0xFF3AA4F5),
            Color(0xFF0754C7),
          ],
          stops: [0, 0.20, 0.66, 1],
        ).createShader(sphereRect),
    );

    canvas.save();
    canvas.clipPath(sphere);

    // Stylised land masses with stronger contrast so the illustration reads
    // immediately as a globe.
    final landPaint = Paint()
      ..color = const Color(0xFFBFEFFF).withValues(alpha: 0.96);
    final continentA = Path()
      ..moveTo(center.dx - radius * 0.76, center.dy - radius * 0.24)
      ..cubicTo(
        center.dx - radius * 0.82,
        center.dy - radius * 0.53,
        center.dx - radius * 0.52,
        center.dy - radius * 0.75,
        center.dx - radius * 0.29,
        center.dy - radius * 0.55,
      )
      ..cubicTo(
        center.dx - radius * 0.12,
        center.dy - radius * 0.43,
        center.dx - radius * 0.31,
        center.dy - radius * 0.22,
        center.dx - radius * 0.43,
        center.dy - radius * 0.08,
      )
      ..cubicTo(
        center.dx - radius * 0.57,
        center.dy + radius * 0.08,
        center.dx - radius * 0.39,
        center.dy + radius * 0.24,
        center.dx - radius * 0.48,
        center.dy + radius * 0.42,
      )
      ..cubicTo(
        center.dx - radius * 0.60,
        center.dy + radius * 0.20,
        center.dx - radius * 0.73,
        center.dy + radius * 0.04,
        center.dx - radius * 0.76,
        center.dy - radius * 0.24,
      )
      ..close();

    final continentB = Path()
      ..moveTo(center.dx - radius * 0.12, center.dy - radius * 0.02)
      ..cubicTo(
        center.dx + radius * 0.02,
        center.dy - radius * 0.19,
        center.dx + radius * 0.28,
        center.dy - radius * 0.15,
        center.dx + radius * 0.29,
        center.dy + radius * 0.02,
      )
      ..cubicTo(
        center.dx + radius * 0.46,
        center.dy + radius * 0.14,
        center.dx + radius * 0.28,
        center.dy + radius * 0.36,
        center.dx + radius * 0.18,
        center.dy + radius * 0.54,
      )
      ..cubicTo(
        center.dx + radius * 0.04,
        center.dy + radius * 0.66,
        center.dx - radius * 0.02,
        center.dy + radius * 0.36,
        center.dx - radius * 0.13,
        center.dy + radius * 0.22,
      )
      ..cubicTo(
        center.dx - radius * 0.21,
        center.dy + radius * 0.11,
        center.dx - radius * 0.24,
        center.dy + radius * 0.03,
        center.dx - radius * 0.12,
        center.dy - radius * 0.02,
      )
      ..close();

    final continentC = Path()
      ..moveTo(center.dx + radius * 0.24, center.dy - radius * 0.65)
      ..cubicTo(
        center.dx + radius * 0.44,
        center.dy - radius * 0.72,
        center.dx + radius * 0.70,
        center.dy - radius * 0.54,
        center.dx + radius * 0.73,
        center.dy - radius * 0.34,
      )
      ..cubicTo(
        center.dx + radius * 0.64,
        center.dy - radius * 0.17,
        center.dx + radius * 0.47,
        center.dy - radius * 0.27,
        center.dx + radius * 0.38,
        center.dy - radius * 0.12,
      )
      ..cubicTo(
        center.dx + radius * 0.27,
        center.dy - radius * 0.25,
        center.dx + radius * 0.18,
        center.dy - radius * 0.43,
        center.dx + radius * 0.24,
        center.dy - radius * 0.65,
      )
      ..close();

    for (final continent in [continentA, continentB, continentC]) {
      canvas.drawPath(continent, landPaint);
      canvas.drawPath(
        continent,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9,
      );
    }

    // Latitude bands.
    final gridPaint = Paint()
      ..color = const Color(0xFFE9FBFF).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (int i = -2; i <= 2; i++) {
      final latitude = i * 0.29;
      final width = 2 * radius * math.sqrt(1 - latitude * latitude * 0.45);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + latitude * radius),
          width: width,
          height: radius * 0.13,
        ),
        gridPaint,
      );
    }

    // Curved longitude bands shift over time to suggest a rotating planet.
    for (int i = 0; i < 5; i++) {
      final longitude = t + i * math.pi / 5;
      final width = math.max(
        radius * 0.16,
        radius * 1.82 * math.cos(longitude).abs(),
      ).toDouble();
      final shift = math.sin(longitude) * radius * 0.10;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + shift, center.dy),
          width: width,
          height: radius * 1.88,
        ),
        gridPaint,
      );
    }

    // Tiny route nodes on the surface reinforce the connectivity theme.
    final routeNodes = <Offset>[
      Offset(center.dx - radius * 0.40, center.dy - radius * 0.08),
      Offset(center.dx - radius * 0.08, center.dy - radius * 0.31),
      Offset(center.dx + radius * 0.25, center.dy + radius * 0.03),
      Offset(center.dx + radius * 0.32, center.dy + radius * 0.37),
    ];
    final routePaint = Paint()
      ..color = const Color(0xFF0878F9).withValues(alpha: 0.72)
      ..strokeWidth = 1.4;
    for (int i = 0; i < routeNodes.length - 1; i++) {
      canvas.drawLine(routeNodes[i], routeNodes[i + 1], routePaint);
    }
    for (final node in routeNodes) {
      canvas.drawCircle(node, 3.8, Paint()..color = Colors.white);
      canvas.drawCircle(node, 2.2, Paint()..color = deglitchBlue);
    }

    canvas.restore();

    // A crisp rim, highlight and front arc add depth.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.94),
      math.pi * 1.08,
      math.pi * 0.37,
      false,
      Paint()
        ..color = const Color(0xFFECFCFF).withValues(alpha: 0.60)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    // Draw the lower/front orbit arc over the globe.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_orbitTilt);
    canvas.drawArc(
      orbitRect,
      0,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF23B7FF).withValues(alpha: 0.88)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    canvas.restore();

    for (int i = 0; i < angles.length; i++) {
      if (math.sin(angles[i]) >= 0) {
        _drawSatellite(
          canvas,
          _orbitPosition(center, orbitRadiusX, orbitRadiusY, angles[i]),
          isShield: i == 0,
          size: i == 0 ? 50 : 43,
        );
      }
    }
  }

  void _drawSatellite(
    Canvas canvas,
    Offset center, {
    required bool isShield,
    required double size,
  }) {
    final unit = size / 44;
    final rect = Rect.fromCenter(
      center: center,
      width: size,
      height: size,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        Radius.circular(size * 0.30),
      ),
      Paint()
        ..color = deglitchBlue.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        Radius.circular(size * 0.30),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        Radius.circular(size * 0.30),
      ),
      Paint()
        ..color = const Color(0xFFB8E5FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final cx = center.dx;
    final cy = center.dy;
    if (isShield) {
      final shield = Path()
        ..moveTo(cx, cy - 13 * unit)
        ..lineTo(cx + 10 * unit, cy - 9 * unit)
        ..lineTo(cx + 8.5 * unit, cy + 2 * unit)
        ..quadraticBezierTo(
          cx + 6 * unit,
          cy + 9 * unit,
          cx,
          cy + 12 * unit,
        )
        ..quadraticBezierTo(
          cx - 6 * unit,
          cy + 9 * unit,
          cx - 8.5 * unit,
          cy + 2 * unit,
        )
        ..lineTo(cx - 10 * unit, cy - 9 * unit)
        ..close();
      canvas.drawPath(shield, Paint()..color = deglitchBlue);
      final check = Path()
        ..moveTo(cx - 4 * unit, cy)
        ..lineTo(cx - 1 * unit, cy + 3 * unit)
        ..lineTo(cx + 5 * unit, cy - 4 * unit);
      canvas.drawPath(
        check,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 2.1 * unit,
      );
    } else {
      final pin = Path()
        ..moveTo(cx, cy + 13 * unit)
        ..cubicTo(
          cx - 2.8 * unit,
          cy + 8 * unit,
          cx - 9 * unit,
          cy + 1 * unit,
          cx - 9 * unit,
          cy - 5 * unit,
        )
        ..cubicTo(
          cx - 9 * unit,
          cy - 16 * unit,
          cx + 9 * unit,
          cy - 16 * unit,
          cx + 9 * unit,
          cy - 5 * unit,
        )
        ..cubicTo(
          cx + 9 * unit,
          cy + 1 * unit,
          cx + 2.8 * unit,
          cy + 8 * unit,
          cx,
          cy + 13 * unit,
        )
        ..close();
      canvas.drawPath(pin, Paint()..color = deglitchBlue);
      canvas.drawCircle(
        Offset(cx, cy - 5 * unit),
        3.5 * unit,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) =>
      oldDelegate.phase != phase;
}

const double _securityOrbitRadiusX = 112;
const double _securityOrbitRadiusY = 61;
const double _securityOrbitTilt = -0.42;

class SecurityIllustration extends StatefulWidget {
  const SecurityIllustration({super.key});

  @override
  State<SecurityIllustration> createState() => _SecurityIllustrationState();
}

class _SecurityIllustrationState extends State<SecurityIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _orbitIcons(double phase, {required bool foreground}) {
    const icons = <IconData>[
      Icons.location_on_rounded,
      Icons.lock_rounded,
      Icons.wifi_rounded,
      Icons.verified_user_rounded,
      Icons.public_rounded,
    ];

    return List<Widget>.generate(icons.length, (index) {
      final angle = phase * math.pi * 2 + index * math.pi * 2 / icons.length;
      final x = math.cos(angle) * _securityOrbitRadiusX;
      final y = math.sin(angle) * _securityOrbitRadiusY;
      final cosTilt = math.cos(_securityOrbitTilt);
      final sinTilt = math.sin(_securityOrbitTilt);
      final point = Offset(
        150 + x * cosTilt - y * sinTilt,
        145 + x * sinTilt + y * cosTilt,
      );
      final isForeground = point.dy >= 145;
      if (isForeground != foreground) {
        return const SizedBox.shrink();
      }

      final size = index == 0 ? 46.0 : 42.0;
      return Positioned(
        left: point.dx - size / 2,
        top: point.dy - size / 2,
        child: _floatingBadge(icons[index], size),
      );
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final phase = _controller.value;
          return SizedBox(
            width: 300,
            height: 290,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Full ring and upper orbit sit behind the logo.
                CustomPaint(
                  size: const Size(300, 290),
                  painter: _SecurityPainter(phase),
                ),
                ..._orbitIcons(phase, foreground: false),

                // Official DēGlitch mark is the visual anchor in the middle.
                Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFD9F0FF),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: deglitchBlue.withValues(alpha: 0.25),
                        blurRadius: 30,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        color: const Color(0xFF20B9FF).withValues(alpha: 0.15),
                        blurRadius: 42,
                        spreadRadius: 9,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(17),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.bolt_rounded,
                      size: 66,
                      color: deglitchBlue,
                    ),
                  ),
                ),

                // Redraw the front half of the orbit over the center mark.
                CustomPaint(
                  size: const Size(300, 290),
                  painter: _SecurityFrontOrbitPainter(phase),
                ),
                ..._orbitIcons(phase, foreground: true),
              ],
            ),
          );
        },
      );

  Widget _floatingBadge(IconData icon, double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFD7EDFF), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: deglitchBlue.withValues(alpha: 0.16),
              blurRadius: 17,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: deglitchBlue, size: size * 0.52),
      );
}

class _SecurityPainter extends CustomPainter {
  _SecurityPainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pulse = 4 * math.sin(phase * math.pi * 2);
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        center,
        78 + pulse + i * 17,
        Paint()
          ..color = deglitchBlue.withValues(alpha: 0.15 - i * 0.032)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3,
      );
    }

    final orbitRect = Rect.fromCenter(
      center: Offset.zero,
      width: _securityOrbitRadiusX * 2,
      height: _securityOrbitRadiusY * 2,
    );
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_securityOrbitTilt);
    canvas.drawOval(
      orbitRect,
      Paint()
        ..color = const Color(0xFF26CFFF).withValues(alpha: 0.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.restore();

    // Small particles support the feeling of a live, secure connection.
    for (int i = 0; i < 16; i++) {
      final a = i / 16 * math.pi * 2 + phase * math.pi * 2 * 0.18;
      final p = Offset(
        center.dx + math.cos(a) * 137,
        center.dy + math.sin(a) * 94,
      );
      canvas.drawCircle(
        p,
        i % 4 == 0 ? 2.5 : 1.5,
        Paint()
          ..color = const Color(0xFF3AAEFF).withValues(
            alpha: 0.25 + 0.42 * (0.5 + 0.5 * math.sin(phase * 6 + i)),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SecurityPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

class _SecurityFrontOrbitPainter extends CustomPainter {
  _SecurityFrontOrbitPainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final orbitRect = Rect.fromCenter(
      center: Offset.zero,
      width: _securityOrbitRadiusX * 2,
      height: _securityOrbitRadiusY * 2,
    );
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_securityOrbitTilt);
    canvas.drawArc(
      orbitRect,
      0,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF12BFFF).withValues(
          alpha: 0.68 + 0.15 * math.sin(phase * math.pi * 2),
        )
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.4,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SecurityFrontOrbitPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

class NetworkIllustration extends StatefulWidget {
  const NetworkIllustration({super.key});

  @override
  State<NetworkIllustration> createState() => _NetworkIllustrationState();
}

class _NetworkIllustrationState extends State<NetworkIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final pulse = 0.97 + 0.03 *
              (0.5 + 0.5 * math.sin(_controller.value * math.pi * 2));
          return SizedBox(
            width: 310,
            height: 285,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _NetworkPainter(_controller.value),
                  ),
                ),

                // AI label floats above the active network map.
                Positioned(
                  top: 1,
                  right: 2,
                  child: Transform.scale(
                    scale: pulse,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0878F9), Color(0xFF28BFFF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.88),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: deglitchBlue.withValues(alpha: 0.20),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Mark the main network hub as the AI-assisted intelligence node.
                Positioned(
                  left: 164 - 19,
                  top: 171 - 19,
                  child: Transform.scale(
                    scale: 0.96 + pulse * 0.04,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF49D7FF), Color(0xFF075FE6)],
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF16BFFF).withValues(alpha: 0.34),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class _NetworkPainter extends CustomPainter {
  _NetworkPainter(this.phase);
  final double phase;
  @override
  void paint(Canvas canvas, Size size) {
    final pts = <Offset>[
      Offset(size.width * .18, size.height * .36),
      Offset(size.width * .35, size.height * .18),
      Offset(size.width * .54, size.height * .31),
      Offset(size.width * .79, size.height * .20),
      Offset(size.width * .27, size.height * .65),
      Offset(size.width * .53, size.height * .60),
      Offset(size.width * .76, size.height * .68),
      Offset(size.width * .50, size.height * .83),
    ];
    final links = <List<int>>[
      [0, 1],
      [1, 2],
      [2, 3],
      [0, 4],
      [4, 5],
      [5, 2],
      [5, 6],
      [5, 7],
      [6, 3],
      [4, 7],
    ];
    final linePaint = Paint()
      ..color = const Color(0xFF54BFFF).withValues(alpha: 0.5)
      ..strokeWidth = 1.7;
    for (final link in links) {
      canvas.drawLine(pts[link[0]], pts[link[1]], linePaint);
      final a = pts[link[0]], b = pts[link[1]];
      final t = (phase + link[0] * 0.12) % 1;
      final p = Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
      canvas.drawCircle(p, 3, Paint()..color = deglitchCyan);
    }
    for (int i = 0; i < pts.length; i++) {
      final p = pts[i];
      canvas.drawCircle(
        p,
        i == 5 ? 21 : 14,
        Paint()..color = deglitchBlue.withValues(alpha: i == 5 ? 0.10 : 0.07),
      );
      canvas.drawCircle(
        p,
        i == 5 ? 10 : 6.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        p,
        i == 5 ? 7.5 : 4.5,
        Paint()
          ..color = i == 5 ? const Color(0xFF0B7BFA) : const Color(0xFF45B7FF),
      );
    }

    // Animated diagnostics bars beneath the network map.
    final barBase = size.height * .94;
    for (int i = 0; i < 7; i++) {
      final h = 14 + 26 * (0.5 + 0.5 * math.sin(phase * math.pi * 2 + i * .86));
      final x = size.width * .23 + i * 22;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, barBase - h, 12, h),
        const Radius.circular(6),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..color = i == 3
              ? deglitchBlue
              : const Color(0xFF79C9FF).withValues(alpha: .72),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
