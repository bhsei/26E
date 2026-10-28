import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/animated_wave_background.dart';
import '../../../widgets/deglitch_brand.dart';
import '../mobile_auth/auth_copy.dart';

class MobileSplashScreen extends StatefulWidget {
  const MobileSplashScreen({super.key});

  @override
  State<MobileSplashScreen> createState() => _MobileSplashScreenState();
}

class _MobileSplashScreenState extends State<MobileSplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _routeTimer;
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3100),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _routeTimer = Timer(const Duration(milliseconds: 3600), _continueToApp);
  }

  Future<void> _continueToApp() async {
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.go('/super-mobile-home');
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    context.go(
      preferences.getBool('deglitch_onboarding_complete') == true
          ? '/sign-in'
          : '/onboarding',
    );
  }

  @override
  void dispose() {
    _routeTimer?.cancel();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF03152F), Color(0xFF052E64), Color(0xFF02132D)],
              stops: [0, 0.57, 1],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.20,
                left: -80,
                right: -80,
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        deglitchBlue.withValues(alpha: 0.24),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned.fill(child: AnimatedWaveBackground()),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 4),
                    GlitchBrand(
                      iconSize: 106,
                      showWordmark: true,
                      darkBackground: true,
                      animated: true,
                      tagline: authText(context, 'tagline'),
                    ),
                    const Spacer(flex: 5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(52, 0, 52, 28),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 3,
                              color: Colors.white.withValues(alpha: 0.12),
                              child: AnimatedBuilder(
                                animation: _progress,
                                builder: (context, _) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.22 + _progress.value * 0.78,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF20D5FF),
                                            Color(0xFF188CFF),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            authText(context, 'loading'),
                            style: const TextStyle(
                              color: Color(0xFFB6D9F9),
                              fontSize: 12,
                              letterSpacing: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
