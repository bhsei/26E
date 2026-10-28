// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DēGlitch';

  @override
  String get home => 'Home';

  @override
  String get servers => 'Servers';

  @override
  String get diagnostics => 'Diagnostics';

  @override
  String get profile => 'Profile';

  @override
  String get more => 'More';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get connecting => 'Connecting';

  @override
  String get connectionError => 'Connection error';

  @override
  String get received => 'Received';

  @override
  String get sent => 'Sent';

  @override
  String get lastHandshake => 'Last handshake';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get serverRecommendation => 'Server Recommendation';

  @override
  String get serverRecommendationDescription =>
      'AI-assisted server suggestions for your connection';

  @override
  String get runDiagnostics => 'Run Diagnostics';

  @override
  String get diagnosticsDescription => 'Check your connection health';

  @override
  String get viewConnectionHistory => 'View Connection History';

  @override
  String get pastConnections => 'See past connections';

  @override
  String get profileAndSettings => 'Profile & Settings';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get language => 'Language';

  @override
  String get activityPreferences => 'Activity Preferences';

  @override
  String get networkProfiles => 'Network Profiles';

  @override
  String get securityAndPrivacy => 'Security & Privacy';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get aboutDeGlitch => 'About DēGlitch';

  @override
  String get logOut => 'Log Out';

  @override
  String get logOutQuestion => 'Log out?';

  @override
  String get logoutPrompt => 'Are you sure you want to log out of DēGlitch?';

  @override
  String get cancel => 'Cancel';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get languageSaved => 'Language preference saved.';

  @override
  String get languageChangeNotConfigured =>
      'Language switching is not connected to the app yet. Connect the locale controller in the app root.';

  @override
  String get premium => 'Premium';

  @override
  String get yourConnectivityToolkit => 'Your connectivity toolkit';

  @override
  String get manageToolsDescription =>
      'Manage tools, connection behavior and support.';

  @override
  String get quickTools => 'Quick Tools';

  @override
  String get recommend => 'Recommend';

  @override
  String get findBetterRoute => 'Find a better route';

  @override
  String get history => 'History';

  @override
  String get connectionPreferences => 'Connection Preferences';

  @override
  String get autoConnect => 'Auto-connect';

  @override
  String get autoConnectDescription =>
      'Connect automatically when enabled by the app';

  @override
  String get liteMode => 'Lite Mode';

  @override
  String get liteModeDescription => 'Reduce non-essential background activity';

  @override
  String get dataSaver => 'Data Saver';

  @override
  String get dataSaverDescription => 'Limit optional background data use';

  @override
  String get moreOptions => 'More Options';

  @override
  String get manageSavedConnectionPreferences =>
      'Manage saved connection preferences';

  @override
  String get splitTunneling => 'Split Tunneling';

  @override
  String get splitTunnelingDescription => 'Choose which apps use the VPN';

  @override
  String get soon => 'Soon';

  @override
  String get reviewPermissionsAndDataControls =>
      'Review permissions and data controls';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get aiAssistantDescription => 'Get help understanding your connection';

  @override
  String get networkBoost => 'Network Boost';

  @override
  String get networkBoostDescription =>
      'Check available signals and apply supported optimisations.';

  @override
  String get networkBoostDisclaimer =>
      'Results depend on your network, device, endpoint and service provider. No fixed speed increase is guaranteed.';

  @override
  String get askAssistant => 'Ask DēGlitch';

  @override
  String get send => 'Send';

  @override
  String get assistantGreeting =>
      'Hi! I can help explain connection status, diagnostics, server choices, Lite Mode and supported settings.';

  @override
  String get assistantUnavailable =>
      'The assistant service is not connected yet. You can still use the available app settings.';

  @override
  String get connectionStatus => 'Connection Status';

  @override
  String get connectedFor => 'Connected for';

  @override
  String get connectionHealth => 'Connection Health';

  @override
  String get speed => 'Speed';

  @override
  String get stability => 'Stability';

  @override
  String get security => 'Security';

  @override
  String get high => 'High';

  @override
  String get stable => 'Stable';

  @override
  String get protected => 'Protected';

  @override
  String get aiRecommended => 'AI Recommended';

  @override
  String get allServers => 'All Servers';

  @override
  String get favorites => 'Favorites';

  @override
  String get recommended => 'Recommended';

  @override
  String get lowestMeasuredLatency => 'Lowest measured latency';

  @override
  String get latency => 'Latency';

  @override
  String get packetLoss => 'Packet Loss';

  @override
  String get healthScore => 'Health Score';

  @override
  String get otherAvailableServers => 'Other Available Servers';

  @override
  String get bestChoice => 'Best Choice';

  @override
  String connectToServer(String serverName) {
    return 'Connect to $serverName';
  }

  @override
  String get diagnosticsComplete => 'Diagnostics Complete';

  @override
  String get checksHaveResults => 'All completed checks have results';

  @override
  String get internetConnection => 'Internet Connection';

  @override
  String get dns => 'DNS';

  @override
  String get packetLossTest => 'Packet Loss Test';

  @override
  String get latencyTest => 'Latency Test';

  @override
  String get jitterTest => 'Jitter Test';

  @override
  String get serverLoad => 'Server Load';

  @override
  String get vpnEndpoint => 'VPN Endpoint';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get passed => 'Passed';

  @override
  String get runAgain => 'Run Again';

  @override
  String get serverTelemetryUnavailable => 'Server telemetry is not connected.';

  @override
  String get tunnelStatusUnavailable =>
      'Live tunnel status is not connected to diagnostics.';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get aiResponseDisclaimer =>
      'I can explain available measurements and suggest supported checks, but I cannot guarantee a particular speed increase.';

  @override
  String get networkBoostStatus => 'Network Boost status';

  @override
  String get noData => 'No data available';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clear => 'Clear';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get retry => 'Retry';

  @override
  String get errorTryAgain => 'Something went wrong. Please try again.';

  @override
  String get noServers => 'No servers are available right now.';

  @override
  String get profileImported => 'Profile imported';

  @override
  String get importSelectProfile => 'Import/select the local profile';

  @override
  String get activityGaming => 'Gaming';

  @override
  String get activityStreaming => 'Streaming';

  @override
  String get activityStudy => 'Studying';

  @override
  String get activityWork => 'Working';

  @override
  String get privacyControls => 'Privacy Controls';

  @override
  String get notifications => 'Notifications';

  @override
  String get languageRestartNote =>
      'The selected language applies throughout the app and is remembered on this device.';

  @override
  String get aboutTagline => 'Smarter Connectivity. A Better Way Forward.';

  @override
  String get serverDetails => 'Server Details';

  @override
  String get reconnect => 'Reconnect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connect => 'Connect';
}
