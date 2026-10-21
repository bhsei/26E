import 'dart:async';
import 'dart:io';

import 'package:de_glitch/constants/colors/colors.dart';
import 'package:de_glitch/services/wireguard_service.dart';
import 'package:de_glitch/widgets/mobile_header_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wireguard/flutter_wireguard.dart' as wg;
import 'package:gap/gap.dart';

class SuperMobileHome extends StatefulWidget {
  const SuperMobileHome({super.key});

  @override
  State<SuperMobileHome> createState() => _SuperMobileHomeState();
}

class _SuperMobileHomeState extends State<SuperMobileHome> with WidgetsBindingObserver {
  final WireGuardService _wireGuard = WireGuardService();
  StreamSubscription<wg.TunnelStatus>? _statusSubscription;
  Timer? _statusPollTimer;
  bool _refreshInProgress = false;
  bool _probeInProgress = false;
  bool _hasLoadedStatus = false;
  bool internetReachable = false;
  DateTime? _lastConnectivityProbe;

  bool isTunnelActive = false;
  bool isBusy = false;
  bool hasConfig = false;
  int selectedTab = 0;
  int receivedBytes = 0;
  int sentBytes = 0;
  int handshakeTimestamp = 0;
  String serverLabel = 'No configuration imported';

  bool get hasHandshake => handshakeTimestamp > 0;

  // A running interface alone does not prove the peer is reachable. A reported
  // handshake, received tunnel traffic, or a successful internet probe does.
  bool get isConnected =>
      isTunnelActive && (hasHandshake || receivedBytes > 0 || internetReachable);

  String get connectionLabel {
    if (isBusy) return 'Connecting...';
    if (!_hasLoadedStatus) return 'Checking tunnel status...';
    if (!isTunnelActive) {
      return hasConfig ? 'Disconnected' : 'Import a configuration';
    }
    if (isConnected) return internetReachable && !hasHandshake
        ? 'Connected — internet verified'
        : 'Connected';
    return 'Tunnel active — checking server response';
  }

  Color get connectionColor {
    if (isBusy) return primaryBlue;
    if (isConnected) return green;
    if (isTunnelActive) return Colors.orange.shade800;
    return Colors.redAccent;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _statusSubscription = _wireGuard.statusStream.listen(
          (status) {
        if (status.name == WireGuardService.tunnelName) {
          _applyTunnelStatus(status);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Status stream error: $error');
      },
    );
    _loadSavedConfigurationAndStatus();
    _startStatusPolling();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Android may keep the VpnService alive while DēGlitch is backgrounded.
      // Always query native state again when the user returns to the app.
      _lastConnectivityProbe = null;
      unawaited(_refreshTunnelStatus());
      _startStatusPolling();
    } else {
      _statusPollTimer?.cancel();
      _statusPollTimer = null;
    }
  }

  void _startStatusPolling() {
    _statusPollTimer?.cancel();
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    _statusPollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || (!hasConfig && !isTunnelActive)) return;
      unawaited(_refreshTunnelStatus());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _statusPollTimer?.cancel();
    _statusSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedConfigurationAndStatus() async {
    try {
      final savedConfig = await _wireGuard.hasConfig();
      final savedLabel = await _wireGuard.getServerLabel();
      if (mounted) {
        setState(() {
          hasConfig = savedConfig;
          serverLabel = savedLabel ?? 'No configuration imported';
        });
      }
      await _refreshTunnelStatus();
    } catch (error) {
      debugPrint('Could not restore state: $error');
    }
  }

  void _applyTunnelStatus(wg.TunnelStatus status) {
    if (!mounted) return;
    setState(() {
      if (status.state == wg.TunnelState.up) {
        isTunnelActive = true;
      } else if (status.state == wg.TunnelState.down) {
        isTunnelActive = false;
        internetReachable = false;
      }
      receivedBytes = status.rx;
      sentBytes = status.tx;
      handshakeTimestamp = status.handshake;
      _hasLoadedStatus = true;
    });
  }

  Future<void> _refreshTunnelStatus() async {
    if (_refreshInProgress) return;
    _refreshInProgress = true;
    try {
      final status = await _wireGuard.getStatus();
      if (status != null) {
        _applyTunnelStatus(status);
        // Some native/platform combinations can reports an active interface
        // before a useful handshake timestamp is available. Verify that the
        // OS data path can actually reach the internet instead of guessing.
        if (isTunnelActive && !hasHandshake && receivedBytes == 0) {
          await _probeInternetIfDue();
        }
      } else if (mounted && !_hasLoadedStatus) {
        setState(() => _hasLoadedStatus = true);
      }
    } catch (error) {
      debugPrint('Could not read status: $error');
      if (mounted && !_hasLoadedStatus) {
        setState(() => _hasLoadedStatus = true);
      }
    } finally {
      _refreshInProgress = false;
    }
  }

  Future<void> _probeInternetIfDue({bool force = false}) async {
    if (!isTunnelActive || _probeInProgress) return;
    final now = DateTime.now();
    final last = _lastConnectivityProbe;
    if (!force && last != null && now.difference(last) < const Duration(seconds: 8)) {
      return;
    }
    _lastConnectivityProbe = now;
    _probeInProgress = true;
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 4);
    var reachable = false;
    try {
      final request = await client
          .getUrl(Uri.parse('https://www.gstatic.com/generate_204'))
          .timeout(const Duration(seconds: 5));
      request.followRedirects = false;
      final response = await request.close().timeout(const Duration(seconds: 5));
      await response.drain<void>();
      reachable = response.statusCode == 204 ||
          (response.statusCode >= 200 && response.statusCode < 400);
    } catch (_) {
      // Do not expose raw network errors or treat a failed probe as connected.
      reachable = false;
    } finally {
      client.close(force: true);
      _probeInProgress = false;
    }
    if (mounted && internetReachable != reachable) {
      setState(() => internetReachable = reachable);
    }
  }

  Future<void> _importWireGuardConfig() async {
    try {
      final importedLabel = await _wireGuard.importConfig();
      if (!mounted || importedLabel == null) return;
      final savedLabel = await _wireGuard.getServerLabel();
      setState(() {
        hasConfig = true;
        serverLabel = savedLabel ?? importedLabel;
        // A newly imported profile has not yet been verified as connected.
      });
      _showMessage('Configuration imported securely.');
    } catch (error) {
      if (mounted) {
        _showMessage('Could not import configuration: ${_friendlyError(error)}');
      }
    }
  }

  Future<void> _handlePowerButton() async {
    if (isBusy) return;

    // The power button controls an active tunnel even if a handshake is pending.
    if (isTunnelActive) {
      setState(() => isBusy = true);
      try {
        await _wireGuard.disconnect();
        await _refreshTunnelStatus();
        if (mounted) _showMessage('Disconnect requested.');
      } catch (error) {
        if (mounted) _showMessage('Disconnect failed: ${_friendlyError(error)}');
      } finally {
        if (mounted) setState(() => isBusy = false);
        await _refreshTunnelStatus();
      }
      return;
    }

    if (!hasConfig) {
      await _importWireGuardConfig();
      if (!mounted || !hasConfig) return;
    }

    setState(() => isBusy = true);
    try {
      await _wireGuard.connect();
      await _refreshTunnelStatus();
      if (mounted) {
        _showMessage(
          isConnected
              ? 'Connection verified.'
              : 'Tunnel started. Waiting for server response.',
        );
      }
    } catch (error) {
      if (mounted) {
        _showMessage('Connection failed: ${_friendlyError(error)}');
      }
    } finally {
      if (mounted) setState(() => isBusy = false);
      await _refreshTunnelStatus();
    }
  }

  Future<void> _showServerOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.file_open_outlined),
              title: Text(hasConfig ? 'Replace configuration' : 'Import configuration'),
              subtitle: const Text('Select a .conf file stored on this device'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _importWireGuardConfig();
              },
            ),
            if (hasConfig)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: const Text('Remove saved configuration'),
                subtitle: Text(isTunnelActive ? 'Disconnect before removing' : 'Delete the locally saved profile'),
                enabled: !isTunnelActive && !isBusy,
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  try {
                    await _wireGuard.removeConfig();
                    if (!mounted) return;
                    setState(() {
                      hasConfig = false;
                      serverLabel = 'No configuration imported';
                      receivedBytes = 0;
                      sentBytes = 0;
                      handshakeTimestamp = 0;
                      internetReachable = false;
                    });
                    _showMessage('Saved configuration removed.');
                  } catch (error) {
                    if (mounted) _showMessage('Could not remove config: ${_friendlyError(error)}');
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    // Native/plugin exceptions can contain implementation details; keep UI errors concise.
    return text.length > 160 ? '${text.substring(0, 157)}...' : text;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KiB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MiB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GiB';
  }

  String _formatHandshake(int timestamp) {
    if (timestamp <= 0) return 'Waiting';
    // Tolerate epoch seconds or epoch milliseconds returned by a native backend.
    final millis = timestamp < 100000000000 ? timestamp * 1000 : timestamp;
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final age = DateTime.now().difference(date);
    if (age.isNegative) return 'Recent';
    if (age.inSeconds < 60) return '${age.inSeconds}s ago';
    if (age.inMinutes < 60) return '${age.inMinutes}m ago';
    if (age.inHours < 24) return '${age.inHours}h ago';
    return '${age.inDays}d ago';
  }

  String get _serverFlag {
    if (serverLabel.startsWith('SG-')) return '🇸🇬';
    if (serverLabel.startsWith('US-')) return '🇺🇸';
    if (serverLabel.startsWith('CA-')) return '🇨🇦';
    if (serverLabel.startsWith('JP-')) return '🇯🇵';
    if (serverLabel.startsWith('NL-')) return '🇳🇱';
    return '🌐';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF064184),
            Color(0xFF00346F),
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Color(0xFF064184),
                    surfaceTintColor: Colors.transparent,
                    title: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: background,
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/pic.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MobileHeaderText(text: 'Elijah Fullah'),
                              const Gap(5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: premium,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: primary,
                                      size: 16,
                                    ),
                                    const Gap(5),
                                    Text(
                                      'Premium',
                                      style: TextStyle(
                                        color: primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {

                          },
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: premium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(10),

                      // Connection card, Quick Access and statistics
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.9,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Connection card
                            Positioned(
                              top: 0,
                              left: 15,
                              right: 15,
                              child: _buildConnectionCard(),
                            ),

                            // Quick Access panel
                            Positioned(
                              top: 280,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(15, 65, 15, 20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.96),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Gap(10),
                                    _buildQuickAccessTitle(),
                                    const Gap(20),
                                    _buildQuickAccess(),
                                  ],
                                ),
                              ),
                            ),

                            // Statistics card above both panels
                            Positioned(
                              top: 265,
                              left: 30,
                              right: 30,
                              child: Material(
                                elevation: 3,
                                color: const Color(0xFFFBFDFF),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFE2F2FF),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: StatItem(
                                          value: _formatBytes(receivedBytes),
                                          label: 'Received',
                                        ),
                                      ),
                                      const StatDivider(),
                                      Expanded(
                                        child: StatItem(
                                          value: _formatBytes(sentBytes),
                                          label: 'Sent',
                                        ),
                                      ),
                                      const StatDivider(),
                                      Expanded(
                                        child: StatItem(
                                          value: _formatHandshake(handshakeTimestamp),
                                          label: 'Last handshake',
                                        ),
                                      ),
                                    ],
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
            ],
          )
      ),
    );
  }

  // Main VPN connection card
  Widget _buildConnectionCard() {
    return Transform.translate(
      offset: const Offset(0, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFFE1F1FF),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A94E8).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow rings
                  Container(
                    height: 128,
                    width: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD8F1FF),
                        width: 3,
                      ),
                    ),
                  ),
                  Container(
                    height: 108,
                    width: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB9E8FF),
                        width: 4,
                      ),
                    ),
                  ),
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF149AFF),
                          Color(0xFF005CE5),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFF6AD4FF),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: isBusy ? null : _handlePowerButton,
                        child: isBusy
                            ? const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                          size: 37,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Connection status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isConnected
                      ? Icons.check_circle
                      : isTunnelActive
                      ? Icons.sync
                      : Icons.cancel,
                  color: connectionColor,
                  size: 19,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    connectionLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isConnected ? textBlue : connectionColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(7),

            InkWell(
              onTap: _showServerOptions,
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_serverFlag, style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      serverLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF24548C),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF477DB4)),
                ],
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildQuickAccessTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 12),
        child: Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: textBlue,
          ),
        ),
      ),
    );
  }

  // Quick access cards
  Widget _buildQuickAccess() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0F0FF),
        ),
      ),
      child: Column(
        children: [
          QuickAccessTile(
            icon: Icons.alt_route_rounded,
            title: 'Server Recommendation',
            subtitle: 'AI selects the best server for you',
            onTap: () => _showMessage('Server Recommendation'),
          ),
          _tileDivider(),
          QuickAccessTile(
            icon: Icons.radio_button_checked,
            title: 'Run Diagnostics',
            subtitle: 'Check your connection health',
            onTap: () => _showMessage('Running diagnostics...'),
          ),
          _tileDivider(),
          QuickAccessTile(
            icon: Icons.history_rounded,
            title: 'View Connection History',
            subtitle: 'See past connections',
            onTap: () => _showMessage('Connection History'),
          ),
        ],
      ),
    );
  }

  Widget _tileDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Divider(
        height: 1,
        color: const Color(0xFFEAF3FC),
      ),
    );
  }

}

// Reusable statistics widget
class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 2,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: mutedBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatDivider extends StatelessWidget {
  const StatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: const Color(0xFFD9ECFC),
    );
  }
}

// Reusable quick access tile
class QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickAccessTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE6F5FF),
                      Color(0xFFD3EDFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: const Color(0xFFD4EBFF),
                  ),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: mutedBlue,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF477DB4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}