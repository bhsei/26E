import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_kri.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('kri'),
    Locale('ru'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DēGlitch'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @servers.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get servers;

  /// No description provided for @diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnostics;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connecting;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionError;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @lastHandshake.
  ///
  /// In en, this message translates to:
  /// **'Last handshake'**
  String get lastHandshake;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @serverRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Server Recommendation'**
  String get serverRecommendation;

  /// No description provided for @serverRecommendationDescription.
  ///
  /// In en, this message translates to:
  /// **'AI-assisted server suggestions for your connection'**
  String get serverRecommendationDescription;

  /// No description provided for @runDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Run Diagnostics'**
  String get runDiagnostics;

  /// No description provided for @diagnosticsDescription.
  ///
  /// In en, this message translates to:
  /// **'Check your connection health'**
  String get diagnosticsDescription;

  /// No description provided for @viewConnectionHistory.
  ///
  /// In en, this message translates to:
  /// **'View Connection History'**
  String get viewConnectionHistory;

  /// No description provided for @pastConnections.
  ///
  /// In en, this message translates to:
  /// **'See past connections'**
  String get pastConnections;

  /// No description provided for @profileAndSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileAndSettings;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @activityPreferences.
  ///
  /// In en, this message translates to:
  /// **'Activity Preferences'**
  String get activityPreferences;

  /// No description provided for @networkProfiles.
  ///
  /// In en, this message translates to:
  /// **'Network Profiles'**
  String get networkProfiles;

  /// No description provided for @securityAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get securityAndPrivacy;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @aboutDeGlitch.
  ///
  /// In en, this message translates to:
  /// **'About DēGlitch'**
  String get aboutDeGlitch;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutQuestion;

  /// No description provided for @logoutPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of DēGlitch?'**
  String get logoutPrompt;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @languageSaved.
  ///
  /// In en, this message translates to:
  /// **'Language preference saved.'**
  String get languageSaved;

  /// No description provided for @languageChangeNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Language switching is not connected to the app yet. Connect the locale controller in the app root.'**
  String get languageChangeNotConfigured;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @yourConnectivityToolkit.
  ///
  /// In en, this message translates to:
  /// **'Your connectivity toolkit'**
  String get yourConnectivityToolkit;

  /// No description provided for @manageToolsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage tools, connection behavior and support.'**
  String get manageToolsDescription;

  /// No description provided for @quickTools.
  ///
  /// In en, this message translates to:
  /// **'Quick Tools'**
  String get quickTools;

  /// No description provided for @recommend.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get recommend;

  /// No description provided for @findBetterRoute.
  ///
  /// In en, this message translates to:
  /// **'Find a better route'**
  String get findBetterRoute;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @connectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Connection Preferences'**
  String get connectionPreferences;

  /// No description provided for @autoConnect.
  ///
  /// In en, this message translates to:
  /// **'Auto-connect'**
  String get autoConnect;

  /// No description provided for @autoConnectDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect automatically when enabled by the app'**
  String get autoConnectDescription;

  /// No description provided for @liteMode.
  ///
  /// In en, this message translates to:
  /// **'Lite Mode'**
  String get liteMode;

  /// No description provided for @liteModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Reduce non-essential background activity'**
  String get liteModeDescription;

  /// No description provided for @dataSaver.
  ///
  /// In en, this message translates to:
  /// **'Data Saver'**
  String get dataSaver;

  /// No description provided for @dataSaverDescription.
  ///
  /// In en, this message translates to:
  /// **'Limit optional background data use'**
  String get dataSaverDescription;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get moreOptions;

  /// No description provided for @manageSavedConnectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage saved connection preferences'**
  String get manageSavedConnectionPreferences;

  /// No description provided for @splitTunneling.
  ///
  /// In en, this message translates to:
  /// **'Split Tunneling'**
  String get splitTunneling;

  /// No description provided for @splitTunnelingDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which apps use the VPN'**
  String get splitTunnelingDescription;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soon;

  /// No description provided for @reviewPermissionsAndDataControls.
  ///
  /// In en, this message translates to:
  /// **'Review permissions and data controls'**
  String get reviewPermissionsAndDataControls;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @aiAssistantDescription.
  ///
  /// In en, this message translates to:
  /// **'Get help understanding your connection'**
  String get aiAssistantDescription;

  /// No description provided for @networkBoost.
  ///
  /// In en, this message translates to:
  /// **'Network Boost'**
  String get networkBoost;

  /// No description provided for @networkBoostDescription.
  ///
  /// In en, this message translates to:
  /// **'Check available signals and apply supported optimisations.'**
  String get networkBoostDescription;

  /// No description provided for @networkBoostDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Results depend on your network, device, endpoint and service provider. No fixed speed increase is guaranteed.'**
  String get networkBoostDisclaimer;

  /// No description provided for @askAssistant.
  ///
  /// In en, this message translates to:
  /// **'Ask DēGlitch'**
  String get askAssistant;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @assistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! I can help explain connection status, diagnostics, server choices, Lite Mode and supported settings.'**
  String get assistantGreeting;

  /// No description provided for @assistantUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The assistant service is not connected yet. You can still use the available app settings.'**
  String get assistantUnavailable;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// No description provided for @connectedFor.
  ///
  /// In en, this message translates to:
  /// **'Connected for'**
  String get connectedFor;

  /// No description provided for @connectionHealth.
  ///
  /// In en, this message translates to:
  /// **'Connection Health'**
  String get connectionHealth;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @stability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get stability;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @protected.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get protected;

  /// No description provided for @aiRecommended.
  ///
  /// In en, this message translates to:
  /// **'AI Recommended'**
  String get aiRecommended;

  /// No description provided for @allServers.
  ///
  /// In en, this message translates to:
  /// **'All Servers'**
  String get allServers;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @lowestMeasuredLatency.
  ///
  /// In en, this message translates to:
  /// **'Lowest measured latency'**
  String get lowestMeasuredLatency;

  /// No description provided for @latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get latency;

  /// No description provided for @packetLoss.
  ///
  /// In en, this message translates to:
  /// **'Packet Loss'**
  String get packetLoss;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @otherAvailableServers.
  ///
  /// In en, this message translates to:
  /// **'Other Available Servers'**
  String get otherAvailableServers;

  /// No description provided for @bestChoice.
  ///
  /// In en, this message translates to:
  /// **'Best Choice'**
  String get bestChoice;

  /// Action button text for connecting to a named server.
  ///
  /// In en, this message translates to:
  /// **'Connect to {serverName}'**
  String connectToServer(String serverName);

  /// No description provided for @diagnosticsComplete.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics Complete'**
  String get diagnosticsComplete;

  /// No description provided for @checksHaveResults.
  ///
  /// In en, this message translates to:
  /// **'All completed checks have results'**
  String get checksHaveResults;

  /// No description provided for @internetConnection.
  ///
  /// In en, this message translates to:
  /// **'Internet Connection'**
  String get internetConnection;

  /// No description provided for @dns.
  ///
  /// In en, this message translates to:
  /// **'DNS'**
  String get dns;

  /// No description provided for @packetLossTest.
  ///
  /// In en, this message translates to:
  /// **'Packet Loss Test'**
  String get packetLossTest;

  /// No description provided for @latencyTest.
  ///
  /// In en, this message translates to:
  /// **'Latency Test'**
  String get latencyTest;

  /// No description provided for @jitterTest.
  ///
  /// In en, this message translates to:
  /// **'Jitter Test'**
  String get jitterTest;

  /// No description provided for @serverLoad.
  ///
  /// In en, this message translates to:
  /// **'Server Load'**
  String get serverLoad;

  /// No description provided for @vpnEndpoint.
  ///
  /// In en, this message translates to:
  /// **'VPN Endpoint'**
  String get vpnEndpoint;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @runAgain.
  ///
  /// In en, this message translates to:
  /// **'Run Again'**
  String get runAgain;

  /// No description provided for @serverTelemetryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server telemetry is not connected.'**
  String get serverTelemetryUnavailable;

  /// No description provided for @tunnelStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Live tunnel status is not connected to diagnostics.'**
  String get tunnelStatusUnavailable;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @aiResponseDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'I can explain available measurements and suggest supported checks, but I cannot guarantee a particular speed increase.'**
  String get aiResponseDisclaimer;

  /// No description provided for @networkBoostStatus.
  ///
  /// In en, this message translates to:
  /// **'Network Boost status'**
  String get networkBoostStatus;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorTryAgain;

  /// No description provided for @noServers.
  ///
  /// In en, this message translates to:
  /// **'No servers are available right now.'**
  String get noServers;

  /// No description provided for @profileImported.
  ///
  /// In en, this message translates to:
  /// **'Profile imported'**
  String get profileImported;

  /// No description provided for @importSelectProfile.
  ///
  /// In en, this message translates to:
  /// **'Import/select the local profile'**
  String get importSelectProfile;

  /// No description provided for @activityGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get activityGaming;

  /// No description provided for @activityStreaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get activityStreaming;

  /// No description provided for @activityStudy.
  ///
  /// In en, this message translates to:
  /// **'Studying'**
  String get activityStudy;

  /// No description provided for @activityWork.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get activityWork;

  /// No description provided for @privacyControls.
  ///
  /// In en, this message translates to:
  /// **'Privacy Controls'**
  String get privacyControls;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @languageRestartNote.
  ///
  /// In en, this message translates to:
  /// **'The selected language applies throughout the app and is remembered on this device.'**
  String get languageRestartNote;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Smarter Connectivity. A Better Way Forward.'**
  String get aboutTagline;

  /// No description provided for @serverDetails.
  ///
  /// In en, this message translates to:
  /// **'Server Details'**
  String get serverDetails;

  /// No description provided for @reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'fr',
    'kri',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'kri':
      return AppLocalizationsKri();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
