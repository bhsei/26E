
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_connection_history/super_mobile_connection_history.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_diagnostics/super_mobile_diagnostics.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_about_deglitch.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_account_information.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_activity_preferences.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_help_support.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_network_profiles.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_security_privacy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_home/super_mobile_home.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_more/super_mobile_more.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_profile.dart';
import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_servers/super_mobile_servers.dart';

import 'package:de_glitch/layout/super_mobile_layout/super_mobile_layout.dart';

class SuperMobileNavigation {
  SuperMobileNavigation._();

  static const String initRoute = '/super-mobile-home';

  static final GlobalKey<NavigatorState> superMobileLayoutKey =
  GlobalKey<NavigatorState>(debugLabel: 'super-mobile-layout');

  static final GlobalKey<NavigatorState> superMobileHomeKey =
  GlobalKey<NavigatorState>(debugLabel: 'super-mobile-home');

  static final GlobalKey<NavigatorState> superMobileServersKey =
  GlobalKey<NavigatorState>(debugLabel: 'super-mobile-servers');

  static final GlobalKey<NavigatorState> superMobileDiagnosticsKey =
  GlobalKey<NavigatorState>(debugLabel: 'super-mobile-diagnostics');

  static final GlobalKey<NavigatorState> superMobileProfileKey =
  GlobalKey<NavigatorState>(debugLabel: 'super-mobile-profile');

  static final GlobalKey<NavigatorState> superMobileMoreKey =
  GlobalKey<NavigatorState>(debugLabel: 'super-mobile-more');

  static final GoRouter superMobileRouter = GoRouter(
    navigatorKey: superMobileLayoutKey,
    initialLocation: initRoute,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SuperMobileLayout(
            superMobileNavigationShell: navigationShell,
          );
        },
        branches: [
          // 0. Home
          StatefulShellBranch(
            navigatorKey: superMobileHomeKey,
            routes: [
              GoRoute(
                path: '/super-mobile-home',
                name: 'super-mobile-home',
                builder: (context, state) {
                  return SuperMobileHome(key: state.pageKey);
                },
                  routes: [
                    GoRoute(
                        path: 'super-mobile-connection-history',
                        name: 'super-mobile-connection-history',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SuperMobileConnectionHistory(
                              key: state.pageKey,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          );
                        }
                    ),
                  ]
              ),
            ],
          ),

          // 1. Servers
          StatefulShellBranch(
            navigatorKey: superMobileServersKey,
            routes: [
              GoRoute(
                path: '/super-mobile-servers',
                name: 'super-mobile-servers',
                builder: (context, state) {
                  return SuperMobileServers(key: state.pageKey);
                },
              ),
            ],
          ),

          // 2. Diagnostics
          StatefulShellBranch(
            navigatorKey: superMobileDiagnosticsKey,
            routes: [
              GoRoute(
                path: '/super-mobile-diagnostics',
                name: 'super-mobile-diagnostics',
                builder: (context, state) {
                  return SuperMobileDiagnostics(key: state.pageKey);
                },
              ),
            ],
          ),

          // 3. Profile
          StatefulShellBranch(
            navigatorKey: superMobileProfileKey,
            routes: [
              GoRoute(
                path: '/super-mobile-profile',
                name: 'super-mobile-profile',
                builder: (context, state) {
                  return SuperMobileProfile(key: state.pageKey);
                },
                  routes: [
                    GoRoute(
                        path: 'super-mobile-account-information',
                        name: 'super-mobile-account-information',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SuperMobileAccountInformation(
                              key: state.pageKey,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          );
                        }
                    ),
                    GoRoute(
                        path: 'super-mobile-activity-preferences',
                        name: 'super-mobile-activity-preferences',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SuperMobileActivityPreferences(
                              key: state.pageKey,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          );
                        }
                    ),
                    GoRoute(
                        path: 'super-mobile-network-profiles',
                        name: 'super-mobile-network-profiles',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SuperMobileNetworkProfiles(
                              key: state.pageKey,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          );
                        }
                    ),
                    GoRoute(
                        path: 'super-mobile-security-privacy',
                        name: 'super-mobile-security-privacy',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SuperMobileSecurityPrivacy(
                              key: state.pageKey,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          );
                        }
                    ),
                    GoRoute(
                        path: 'super-mobile-help-support',
                        name: 'super-mobile-help-support',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SuperMobileHelpSupport(
                              key: state.pageKey,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          );
                        }
                    ),
                    GoRoute(
                        path: 'super-mobile-about-deglitch',
                        name: 'super-mobile-about-deglitch',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SuperMobileAboutDeGlitch(
                              key: state.pageKey,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          );
                        }
                    ),
                  ]
              ),
            ],
          ),

          // 4. More
          StatefulShellBranch(
            navigatorKey: superMobileMoreKey,
            routes: [
              GoRoute(
                path: '/super-mobile-more',
                name: 'super-mobile-more',
                builder: (context, state) {
                  return SuperMobileMore(key: state.pageKey);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
