import 'package:de_glitch/l10n/app_localizations.dart';
import 'package:de_glitch/services/language_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../controllers/super_mobile_router/super_mobile_router.dart';


export 'auth_checker_logic.dart'
    show
    AuthChecker,
    AuthCheckerRoutes,
    AuthRoleException,
    AuthRoleService,
    AuthRouterGuard,
    GoRouterAuthRefresh;


class AuthApp extends StatefulWidget {
  const AuthApp({super.key});

  @override
  State<AuthApp> createState() => _AuthAppState();
}

class _AuthAppState extends State<AuthApp> {
  late final LanguageController _languageController;
  late Future<void> _initialization;
  SuperMobileNavigation? _navigation;

  @override
  void initState() {
    super.initState();
    _languageController = LanguageController();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    await _languageController.load();
    if (_navigation == null) {
      final navigation = SuperMobileNavigation(_languageController);
      navigation.superMobileRouter;
      _navigation = navigation;
    }
  }

  void _retryInitialization() {
    setState(() {
      _initialization = _initialize();
    });
  }

  @override
  void dispose() {
    _navigation?.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _AppInitializationScreen(),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _AppInitializationError(onRetry: _retryInitialization),
          );
        }

        return AnimatedBuilder(
          animation: _languageController,
          builder: (context, _) {
            return MaterialApp.router(
              title: 'DēGlitch',
              debugShowCheckedModeBanner: false,
              locale: _languageController.locale,
              supportedLocales: LanguageController.supportedLocales,
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                AppLocalizations.delegate,
                _KrioAwareMaterialLocalizationsDelegate(),
                _KrioAwareCupertinoLocalizationsDelegate(),
                GlobalWidgetsLocalizations.delegate,
              ],
              routerConfig: _navigation!.superMobileRouter,
            );
          },
        );
      },
    );
  }
}


class _AppInitializationScreen extends StatelessWidget {
  const _AppInitializationScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F9FF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFF0878F9),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Preparing DēGlitch…',
              style: TextStyle(
                color: Color(0xFF244D7A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppInitializationError extends StatelessWidget {
  const _AppInitializationError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFF0878F9),
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'DēGlitch could not finish starting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF102D50),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Check the app setup and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF5D7895), height: 1.5),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onRetry,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0878F9),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Retry'),
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

/// Flutter's Material labels fall back to English when the app language is
/// Krio; DēGlitch's own AppLocalizations strings remain in Krio.
class _KrioAwareMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _KrioAwareMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'kri' ||
        GlobalMaterialLocalizations.delegate.isSupported(locale);
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    final frameworkLocale =
    locale.languageCode == 'kri' ? const Locale('en') : locale;
    return GlobalMaterialLocalizations.delegate.load(frameworkLocale);
  }

  @override
  bool shouldReload(_KrioAwareMaterialLocalizationsDelegate old) => false;
}

/// Flutter's Cupertino labels fall back to English when the app language is
/// Krio; DēGlitch's own AppLocalizations strings remain in Krio.
class _KrioAwareCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _KrioAwareCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'kri' ||
        GlobalCupertinoLocalizations.delegate.isSupported(locale);
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    final frameworkLocale =
    locale.languageCode == 'kri' ? const Locale('en') : locale;
    return GlobalCupertinoLocalizations.delegate.load(frameworkLocale);
  }

  @override
  bool shouldReload(_KrioAwareCupertinoLocalizationsDelegate old) => false;
}
