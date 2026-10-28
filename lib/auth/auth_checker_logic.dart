import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/mobile/mobile_auth/mobile_sign_in_screen.dart';
import '../screens/mobile/mobile_onboarding/mobile_onboarding_screen.dart';

/// Paths used by the entry/auth checker and by the GoRouter redirect guard.
/// Keep these aligned with paths registered in the app's routers.
abstract final class AuthCheckerRoutes {
  static const entry = '/auth-checker';
  static const onboarding = '/mobile-onboarding';
  static const signIn = '/mobile-sign-in';
  static const signUp = '/mobile-sign-up';
  static const forgotPassword = '/mobile-forgot-password';

  static const superHome = '/super-mobile-home';
  static const adminHome = '/admin-mobile-home';
  static const endUserHome = '/enduser-mobile-home';

  static const onboardingPreferenceKey = 'deglitch_onboarding_complete';

  static const publicPaths = <String>{
    onboarding,
    signIn,
    signUp,
    forgotPassword,
    // Temporary compatibility aliases used by older auth-screen code.
    '/sign-in',
    '/sign-up',
    '/forgot-password',
  };

  static const roleDestinations = <String, String>{
    'super': superHome,
    'admin': adminHome,
    'enduser': endUserHome,
  };

  static String? destinationForRole(String role) => roleDestinations[role];

  static String? prefixForRole(String role) {
    switch (role) {
      case 'super':
        return '/super-mobile-';
      case 'admin':
        return '/admin-mobile-';
      case 'enduser':
        return '/enduser-mobile-';
      default:
        return null;
    }
  }
}

/// Loads the signed-in user's assigned role from `users/{uid}.role`.
///
/// Role assignment must be trusted/server-controlled. New public registrations
/// should receive `enduser`; do not let a client choose `super` or `admin`.
class AuthRoleService {
  AuthRoleService._();

  static final Map<String, Future<String>> _roleRequests = {};

  static Future<String> roleFor(User user, {bool forceRefresh = false}) {
    if (forceRefresh) {
      _roleRequests.remove(user.uid);
    }
    return _roleRequests.putIfAbsent(user.uid, () => _loadRole(user));
  }

  static void invalidate(String uid) => _roleRequests.remove(uid);

  static void clearCache() => _roleRequests.clear();

  static Future<String> _loadRole(User user) async {
    // Account registration can create the Firebase Auth user moments before
    // the profile document write completes. Briefly retry a missing document.
    DocumentSnapshot<Map<String, dynamic>>? snapshot;
    for (var attempt = 0; attempt < 4; attempt++) {
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists || attempt == 3) break;
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    if (snapshot == null || !snapshot.exists) {
      throw const AuthRoleException(
        'Your account exists, but its user profile has not been created yet.',
      );
    }

    final data = snapshot.data();
    final rawRole = data?['role'];
    if (rawRole is! String || rawRole.trim().isEmpty) {
      throw const AuthRoleException(
        'Your account does not have a role assigned yet. Please contact support.',
      );
    }

    final normalized = rawRole
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s_-]+'), '');

    switch (normalized) {
      case 'super':
      case 'superadmin':
      case 'superuser':
        return 'super';
      case 'admin':
      case 'administrator':
        return 'admin';
      case 'enduser':
      case 'user':
      case 'customer':
        return 'enduser';
      default:
        throw AuthRoleException('Unsupported account role: "$rawRole".');
    }
  }
}

class AuthRoleException implements Exception {
  const AuthRoleException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Startup gate. It deliberately replaces the currently crashing splash screen.
/// First install -> onboarding; signed-out returning user -> sign-in; signed-in
/// user -> resolve Firestore role and navigate to that role's router destination.
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  late final Future<bool> _onboardingComplete = _readOnboardingComplete();

  Future<bool> _readOnboardingComplete() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getBool(
            AuthCheckerRoutes.onboardingPreferenceKey,
          ) ??
          false;
    } catch (_) {
      // If local preferences are unavailable, default to the first-run guide.
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, authSnapshot) {
        if (authSnapshot.hasError) {
          return _AuthCheckerMessage(
            title: 'Unable to check your session',
            message: 'Please check your connection and try again.',
            primaryLabel: 'Retry',
            onPrimary: () => setState(() {}),
          );
        }

        if (authSnapshot.connectionState == ConnectionState.waiting &&
            authSnapshot.data == null) {
          return const _AuthCheckerLoading();
        }

        final user = authSnapshot.data;
        if (user == null) {
          return FutureBuilder<bool>(
            future: _onboardingComplete,
            builder: (context, preferencesSnapshot) {
              if (preferencesSnapshot.connectionState != ConnectionState.done) {
                return const _AuthCheckerLoading();
              }

              if (preferencesSnapshot.data != true) {
                return const MobileOnboardingScreen();
              }

              return const MobileSignInScreen();
            },
          );
        }

        return _AuthenticatedRoleGate(user: user);
      },
    );
  }
}

class _AuthenticatedRoleGate extends StatefulWidget {
  const _AuthenticatedRoleGate({required this.user});
  final User user;

  @override
  State<_AuthenticatedRoleGate> createState() => _AuthenticatedRoleGateState();
}

class _AuthenticatedRoleGateState extends State<_AuthenticatedRoleGate> {
  late Future<String> _roleFuture;

  @override
  void initState() {
    super.initState();
    _roleFuture = AuthRoleService.roleFor(widget.user);
  }

  @override
  void didUpdateWidget(covariant _AuthenticatedRoleGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.uid != widget.user.uid) {
      _roleFuture = AuthRoleService.roleFor(widget.user, forceRefresh: true);
    }
  }

  void _retry() {
    setState(() {
      _roleFuture = AuthRoleService.roleFor(widget.user, forceRefresh: true);
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    AuthRoleService.invalidate(widget.user.uid);
    if (!mounted) return;
    context.go(AuthCheckerRoutes.entry);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _roleFuture,
      builder: (context, roleSnapshot) {
        if (roleSnapshot.connectionState != ConnectionState.done) {
          return const _AuthCheckerLoading(
            message: 'Checking your account role…',
          );
        }

        if (roleSnapshot.hasError) {
          final error = roleSnapshot.error;
          final message = error is AuthRoleException
              ? error.message
              : 'We could not load your account role. Check your connection and try again.';
          return _AuthCheckerMessage(
            title: 'Account setup needs attention',
            message: message,
            primaryLabel: 'Retry',
            onPrimary: _retry,
            secondaryLabel: 'Sign out',
            onSecondary: _signOut,
          );
        }

        final role = roleSnapshot.data!;
        final destination = AuthCheckerRoutes.destinationForRole(role);
        if (destination == null) {
          return _AuthCheckerMessage(
            title: 'Role route not configured',
            message: 'The "$role" role has no destination registered in the app router.',
            primaryLabel: 'Retry',
            onPrimary: _retry,
            secondaryLabel: 'Sign out',
            onSecondary: _signOut,
          );
        }

        return _NavigateToRole(destination: destination);
      },
    );
  }
}

class _NavigateToRole extends StatefulWidget {
  const _NavigateToRole({required this.destination});
  final String destination;

  @override
  State<_NavigateToRole> createState() => _NavigateToRoleState();
}

class _NavigateToRoleState extends State<_NavigateToRole> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(widget.destination);
    });
  }

  @override
  void didUpdateWidget(covariant _NavigateToRole oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destination != widget.destination) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(widget.destination);
      });
    }
  }

  @override
  Widget build(BuildContext context) => const _AuthCheckerLoading(
        message: 'Opening your DēGlitch workspace…',
      );
}

/// GoRouter redirect guard. Use as `redirect: AuthRouterGuard.redirect` and
/// pair it with [GoRouterAuthRefresh] so sign-in/sign-out events are observed.
class AuthRouterGuard {
  AuthRouterGuard._();

  static Future<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final path = state.uri.path;

    if (path == '/') return AuthCheckerRoutes.entry;
    if (path == AuthCheckerRoutes.entry) return null;

    final user = FirebaseAuth.instance.currentUser;
    final isPublic = AuthCheckerRoutes.publicPaths.contains(path);

    if (user == null) {
      return isPublic ? null : AuthCheckerRoutes.entry;
    }

    // Authenticated users should leave public onboarding/auth pages and pass
    // through the checker so their role decides which shell opens.
    if (isPublic) return AuthCheckerRoutes.entry;

    try {
      final role = await AuthRoleService.roleFor(user);
      final expectedPrefix = AuthCheckerRoutes.prefixForRole(role);
      if (expectedPrefix == null) return AuthCheckerRoutes.entry;
      if (path.startsWith(expectedPrefix)) return null;
      return AuthCheckerRoutes.destinationForRole(role) ??
          AuthCheckerRoutes.entry;
    } catch (_) {
      // The checker presents a recoverable message for missing/invalid roles.
      return AuthCheckerRoutes.entry;
    }
  }
}

/// Re-runs GoRouter redirects whenever Firebase authentication state changes.
class GoRouterAuthRefresh extends ChangeNotifier {
  GoRouterAuthRefresh(Stream<dynamic> stream) {
    _subscription = stream.listen((event) {
      // Refresh a user's cached role on auth events and discard cache on sign-out.
      if (event is User) {
        AuthRoleService.invalidate(event.uid);
      } else {
        AuthRoleService.clearCache();
      }
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _AuthCheckerLoading extends StatelessWidget {
  const _AuthCheckerLoading({this.message = 'Preparing DēGlitch…'});
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF4F9FF),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF0878F9),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF244D7A),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

class _AuthCheckerMessage extends StatelessWidget {
  const _AuthCheckerMessage({
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final Future<void> Function()? onSecondary;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF4F9FF),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      color: Color(0xFF0878F9),
                      size: 54,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF102D50),
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF5D7895),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onPrimary,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0878F9),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(primaryLabel),
                      ),
                    ),
                    if (secondaryLabel != null && onSecondary != null) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => onSecondary!(),
                        child: Text(secondaryLabel!),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.go(AuthCheckerRoutes.entry),
                      child: const Text('Return to account check'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
