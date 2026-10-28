import 'dart:math' as math;
import 'package:de_glitch/keep/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/deglitch_brand.dart';
import '../screens/mobile/mobile_auth/auth_copy.dart';

class MobileOnboardingScreens extends StatefulWidget {
  const MobileOnboardingScreens({super.key});

  @override
  State<MobileOnboardingScreens> createState() => _MobileOnboardingScreenState();
}

class _MobileOnboardingScreenState extends State<MobileOnboardingScreens> {
  final PageController _pageController = PageController();
  int _page = 0;
  bool _saving = false;

  Future<void> _finishOnboarding() async {
    if (_saving) return;
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('deglitch_onboarding_complete', true);
    if (!mounted) return;
    context.go('/sign-in');
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
                  padding: const EdgeInsets.fromLTRB(28, 4, 28, 24),
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
                      const SizedBox(height: 23),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF168BFF), Color(0xFF0866E9)],
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
                                : Text(
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
                          ),
                        ),
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

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.51);
    final radius = math.min(size.width * 0.34, size.height * 0.35).toDouble();
    final t = phase * math.pi * 2;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.91),
        width: radius * 1.85,
        height: radius * 0.27,
      ),
      Paint()
        ..color = const Color(0xFF7BCBFF).withValues(alpha: 0.17)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawOval(
      Rect.fromCircle(center: center, radius: radius + 12),
      Paint()
        ..color = const Color(
          0xFF74D4FF,
        ).withValues(alpha: 0.10 + 0.06 * math.sin(t))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2.45,
        height: radius * 0.66,
      ),
      Paint()
        ..color = const Color(0xFF4AB9FF).withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final sphereRect = Rect.fromCircle(center: center, radius: radius);
    final sphere = Path()..addOval(sphereRect);
    canvas.drawPath(
      sphere,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.38, -0.48),
          radius: 1.2,
          colors: [
            Color(0xFFB9F0FF),
            Color(0xFF55BFFF),
            Color(0xFF1675E9),
            Color(0xFF0754C7),
          ],
          stops: [0, 0.22, 0.72, 1],
        ).createShader(sphereRect),
    );
    canvas.save();
    canvas.clipPath(sphere);

    // Soft stylized land masses; the shifting grid below gives the impression
    // of a rotating globe without relying on a raster image.
    final landPaint = Paint()
      ..color = const Color(0xFFB3E9FF).withValues(alpha: 0.9);
    final continentA = Path()
      ..moveTo(center.dx - radius * 0.74, center.dy - radius * 0.25)
      ..cubicTo(
        center.dx - radius * 0.82,
        center.dy - radius * 0.57,
        center.dx - radius * 0.47,
        center.dy - radius * 0.74,
        center.dx - radius * 0.28,
        center.dy - radius * 0.55,
      )
      ..cubicTo(
        center.dx - radius * 0.13,
        center.dy - radius * 0.45,
        center.dx - radius * 0.35,
        center.dy - radius * 0.25,
        center.dx - radius * 0.42,
        center.dy - radius * 0.08,
      )
      ..cubicTo(
        center.dx - radius * 0.52,
        center.dy + radius * 0.03,
        center.dx - radius * 0.41,
        center.dy + radius * 0.24,
        center.dx - radius * 0.48,
        center.dy + radius * 0.40,
      )
      ..cubicTo(
        center.dx - radius * 0.59,
        center.dy + radius * 0.17,
        center.dx - radius * 0.72,
        center.dy + radius * 0.04,
        center.dx - radius * 0.74,
        center.dy - radius * 0.25,
      )
      ..close();
    final continentB = Path()
      ..moveTo(center.dx - radius * 0.10, center.dy - radius * 0.02)
      ..cubicTo(
        center.dx + radius * 0.10,
        center.dy - radius * 0.19,
        center.dx + radius * 0.29,
        center.dy - radius * 0.13,
        center.dx + radius * 0.28,
        center.dy + radius * 0.03,
      )
      ..cubicTo(
        center.dx + radius * 0.45,
        center.dy + radius * 0.13,
        center.dx + radius * 0.28,
        center.dy + radius * 0.35,
        center.dx + radius * 0.19,
        center.dy + radius * 0.54,
      )
      ..cubicTo(
        center.dx + radius * 0.04,
        center.dy + radius * 0.67,
        center.dx - radius * 0.03,
        center.dy + radius * 0.36,
        center.dx - radius * 0.13,
        center.dy + radius * 0.22,
      )
      ..cubicTo(
        center.dx - radius * 0.20,
        center.dy + radius * 0.11,
        center.dx - radius * 0.25,
        center.dy + radius * 0.04,
        center.dx - radius * 0.10,
        center.dy - radius * 0.02,
      )
      ..close();
    canvas.drawPath(continentA, landPaint);
    canvas.drawPath(continentB, landPaint);

    final gridPaint = Paint()
      ..color = const Color(0xFFE1F8FF).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = -2; i <= 2; i++) {
      final y = center.dy + radius * i * 0.31;
      final h = math
          .max(5.0, radius * 0.29 * (1 - (i.abs() * 0.23)))
          .toDouble();
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, y),
          width: radius * 1.95,
          height: h,
        ),
        gridPaint,
      );
    }
    for (int i = 0; i < 5; i++) {
      final widthScale =
          0.13 + 0.84 * (0.5 + 0.5 * math.cos(t + i * math.pi / 4));
      final shift = math.sin(t + i * 0.7) * radius * 0.11;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + shift, center.dy),
          width: radius * 2 * widthScale,
          height: radius * 1.95,
        ),
        gridPaint,
      );
    }
    canvas.restore();

    // Four location beacons move gently around the globe.
    for (int i = 0; i < 4; i++) {
      final a = t * 0.42 + i * math.pi / 2 - 0.6;
      final p = Offset(
        center.dx + math.cos(a) * radius * 1.23,
        center.dy + math.sin(a) * radius * 0.92,
      );
      canvas.drawCircle(p, 9.0, Paint()..color = Colors.white);
      canvas.drawCircle(p, 6.0, Paint()..color = deglitchBlue);
      canvas.drawCircle(p, 2.3, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        13.0 + 2 * (0.5 + 0.5 * math.sin(t + i)),
        Paint()
          ..color = deglitchBlue.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) =>
      oldDelegate.phase != phase;
}

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

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => SizedBox(
      width: 300,
      height: 290,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(300, 290),
            painter: _SecurityPainter(_controller.value),
          ),
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6EDCFF),
                  Color(0xFF0878F9),
                  Color(0xFF104CC9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: deglitchBlue.withValues(alpha: 0.28),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.78),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.shield_moon_rounded,
              size: 69,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 30,
            right: 47,
            child: _floatingBadge(Icons.lock_rounded, 43),
          ),
          Positioned(
            bottom: 42,
            left: 35,
            child: _floatingBadge(Icons.verified_user_rounded, 42),
          ),
          Positioned(
            bottom: 41,
            right: 37,
            child: _floatingBadge(Icons.wifi_rounded, 42),
          ),
        ],
      ),
    ),
  );

  Widget _floatingBadge(IconData icon, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFD7EDFF)),
      boxShadow: [
        BoxShadow(
          color: deglitchBlue.withValues(alpha: 0.12),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Icon(icon, color: deglitchBlue, size: 21),
  );
}

class _SecurityPainter extends CustomPainter {
  _SecurityPainter(this.phase);
  final double phase;
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = 83.0 + 4 * math.sin(phase * math.pi * 2);
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        c,
        r + i * 16,
        Paint()
          ..color = deglitchBlue.withValues(alpha: 0.16 - i * 0.035)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3,
      );
    }
    final orbitRect = Rect.fromCenter(
      center: c,
      width: r * 2.74,
      height: r * 1.12,
    );
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-0.42);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: orbitRect.width,
        height: orbitRect.height,
      ),
      Paint()
        ..color = const Color(0xFF26CFFF).withValues(alpha: 0.48)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );
    final dot = Offset(
      math.cos(phase * math.pi * 2) * orbitRect.width / 2,
      math.sin(phase * math.pi * 2) * orbitRect.height / 2,
    );
    canvas.drawCircle(dot, 5, Paint()..color = deglitchCyan);
    canvas.drawCircle(
      dot,
      10,
      Paint()..color = deglitchCyan.withValues(alpha: 0.17),
    );
    canvas.restore();
    for (int i = 0; i < 12; i++) {
      final a = i / 12 * math.pi * 2 + phase * math.pi * 2 * 0.25;
      final p = Offset(
        c.dx + math.cos(a) * (r + 39),
        c.dy + math.sin(a) * (r + 28),
      );
      canvas.drawCircle(
        p,
        i % 3 == 0 ? 2.6 : 1.5,
        Paint()
          ..color = const Color(0xFF3AAEFF).withValues(
            alpha: 0.32 + 0.4 * (0.5 + 0.5 * math.sin(phase * 6 + i)),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SecurityPainter oldDelegate) =>
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
    builder: (context, _) => SizedBox(
      width: 310,
      height: 285,
      child: CustomPaint(painter: _NetworkPainter(_controller.value)),
    ),
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
