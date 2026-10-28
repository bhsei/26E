import 'package:flutter/material.dart';

/// DēGlitch More hub.
///
/// This screen groups useful tools, connection preferences and help links.
/// Connect callbacks to the real router/services in the app shell. Local
/// switches are prototype state unless the corresponding callbacks are wired.
class SuperMobileMore extends StatefulWidget {
  const SuperMobileMore({
    super.key,
    this.onDiagnostics,
    this.onServerRecommendation,
    this.onConnectionHistory,
    this.onNetworkProfiles,
    this.onSecurityPrivacy,
    this.onHelpSupport,
    this.onAbout,
    this.onAutoConnectChanged,
    this.onLiteModeChanged,
    this.onDataSaverChanged,
    this.onSplitTunneling,
    this.initialAutoConnect = true,
    this.initialLiteMode = false,
    this.initialDataSaver = false,
    this.appVersion = '1.1',
  });

  final VoidCallback? onDiagnostics;
  final VoidCallback? onServerRecommendation;
  final VoidCallback? onConnectionHistory;
  final VoidCallback? onNetworkProfiles;
  final VoidCallback? onSecurityPrivacy;
  final VoidCallback? onHelpSupport;
  final VoidCallback? onAbout;
  final ValueChanged<bool>? onAutoConnectChanged;
  final ValueChanged<bool>? onLiteModeChanged;
  final ValueChanged<bool>? onDataSaverChanged;
  final VoidCallback? onSplitTunneling;
  final bool initialAutoConnect;
  final bool initialLiteMode;
  final bool initialDataSaver;
  final String appVersion;

  @override
  State<SuperMobileMore> createState() => _SuperMobileMoreState();
}

class _SuperMobileMoreState extends State<SuperMobileMore> {
  static const Color _blue = Color(0xFF0878F9);
  static const Color _deepBlue = Color(0xFF12447F);
  static const Color _mutedBlue = Color(0xFF7193B7);
  static const Color _page = Color(0xFFF3F8FD);
  static const Color _line = Color(0xFFDDEBFA);

  late bool _autoConnect;
  late bool _liteMode;
  late bool _dataSaver;

  @override
  void initState() {
    super.initState();
    _autoConnect = widget.initialAutoConnect;
    _liteMode = widget.initialLiteMode;
    _dataSaver = widget.initialDataSaver;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _open(String label, VoidCallback? callback) {
    if (callback != null) {
      callback();
    } else {
      _showMessage('$label is not connected yet.');
    }
  }

  void _setAutoConnect(bool value) {
    setState(() => _autoConnect = value);
    widget.onAutoConnectChanged?.call(value);
    if (widget.onAutoConnectChanged == null) {
      _showMessage('Auto-connect changed for this screen only.');
    }
  }

  void _setLiteMode(bool value) {
    setState(() => _liteMode = value);
    widget.onLiteModeChanged?.call(value);
    if (widget.onLiteModeChanged == null) {
      _showMessage('Lite Mode changed for this screen only.');
    }
  }

  void _setDataSaver(bool value) {
    setState(() => _dataSaver = value);
    widget.onDataSaverChanged?.call(value);
    if (widget.onDataSaverChanged == null) {
      _showMessage('Data Saver changed for this screen only.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        /*leading: IconButton(
          tooltip: 'Back',
          onPressed: _isRunning ? _cancel : () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          color: _deepBlue,
        ),*/
        title: const Text(
          'More',
          style: TextStyle(
            color: _deepBlue,
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _buildIntroCard(),
            const SizedBox(height: 22),
            const _SectionHeading(title: 'QUICK TOOLS'),
            const SizedBox(height: 10),
            _buildQuickTools(),
            const SizedBox(height: 22),
            const _SectionHeading(title: 'CONNECTION PREFERENCES'),
            const SizedBox(height: 10),
            _buildPreferenceCard(),
            const SizedBox(height: 22),
            const _SectionHeading(title: 'MORE OPTIONS'),
            const SizedBox(height: 10),
            _buildMoreOptions(),
            const SizedBox(height: 22),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF6FF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1674C8),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _blue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCFE8FF)),
            ),
            child: const Icon(Icons.grid_view_rounded, color: _blue, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your connectivity toolkit',
                  style: TextStyle(
                    color: _deepBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Manage tools, connection behavior and support.',
                  style: TextStyle(
                    color: _mutedBlue,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTools() {
    return Row(
      children: [
        Expanded(
          child: _QuickToolCard(
            icon: Icons.speed_rounded,
            title: 'Diagnostics',
            subtitle: 'Check connection',
            onTap: () => _open('Diagnostics', widget.onDiagnostics),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickToolCard(
            icon: Icons.alt_route_rounded,
            title: 'Recommend',
            subtitle: 'Find a better route',
            onTap: () =>
                _open('Server Recommendation', widget.onServerRecommendation),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickToolCard(
            icon: Icons.history_rounded,
            title: 'History',
            subtitle: 'Past sessions',
            onTap: () =>
                _open('Connection History', widget.onConnectionHistory),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          _PreferenceTile(
            icon: Icons.power_settings_new_rounded,
            title: 'Auto-connect',
            subtitle: 'Connect automatically when enabled by the app',
            value: _autoConnect,
            onChanged: _setAutoConnect,
          ),
          const _SoftDivider(),
          _PreferenceTile(
            icon: Icons.battery_saver_rounded,
            title: 'Lite Mode',
            subtitle: 'Reduce non-essential background activity',
            value: _liteMode,
            onChanged: _setLiteMode,
          ),
          const _SoftDivider(),
          _PreferenceTile(
            icon: Icons.data_saver_on_rounded,
            title: 'Data Saver',
            subtitle: 'Limit optional background data use',
            value: _dataSaver,
            onChanged: _setDataSaver,
          ),
        ],
      ),
    );
  }

  Widget _buildMoreOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.settings_ethernet_rounded,
            title: 'Network Profiles',
            subtitle: 'Manage saved connection preferences',
            onTap: () => _open('Network Profiles', widget.onNetworkProfiles),
          ),
          const _SoftDivider(),
          _OptionTile(
            icon: Icons.call_split_rounded,
            title: 'Split Tunneling',
            subtitle: 'Choose which apps use the VPN',
            trailing: const _ComingSoonLabel(),
            onTap: () {
              if (widget.onSplitTunneling != null) {
                widget.onSplitTunneling!();
              } else {
                _showMessage(
                  'Split Tunneling is not enabled in the current prototype.',
                );
              }
            },
          ),
          const _SoftDivider(),
          _OptionTile(
            icon: Icons.security_rounded,
            title: 'Security & Privacy',
            subtitle: 'Review permissions and data controls',
            onTap: () => _open('Security & Privacy', widget.onSecurityPrivacy),
          ),
          const _SoftDivider(),
          _OptionTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Troubleshooting and FAQs',
            onTap: () => _open('Help & Support', widget.onHelpSupport),
          ),
          const _SoftDivider(),
          _OptionTile(
            icon: Icons.info_outline_rounded,
            title: 'About DēGlitch',
            subtitle: 'Version, app information and credits',
            onTap: () => _open('About DēGlitch', widget.onAbout),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F3FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.shield_moon_outlined, color: _blue, size: 22),
        ),
        const SizedBox(height: 9),
        const Text(
          'DēGlitch',
          style: TextStyle(
            color: _deepBlue,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Version ${widget.appVersion} · Detect. Adapt. Connect.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: _mutedBlue, fontSize: 11),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Text(
        title,
        style: const TextStyle(
          color: _SuperMobileMoreState._deepBlue,
          fontSize: 11,
          letterSpacing: 0.7,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _QuickToolCard extends StatelessWidget {
  const _QuickToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 116),
          padding: const EdgeInsets.fromLTRB(9, 13, 9, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDCEBFA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F4FF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: const Color(0xFF0878F9), size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF12447F),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF7193B7),
                  fontSize: 9,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 9, 8, 9),
      child: Row(
        children: [
          _LeadingIcon(icon: icon),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF12447F),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7193B7),
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF0878F9),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              _LeadingIcon(icon: icon),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF12447F),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7193B7),
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                trailing!,
              ] else ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 21,
                  color: Color(0xFF7193B7),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE9F6FF), Color(0xFFDCEFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6EBFF)),
      ),
      child: Icon(icon, color: const Color(0xFF0878F9), size: 20),
    );
  }
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFEAF2FB)),
    );
  }
}

class _ComingSoonLabel extends StatelessWidget {
  const _ComingSoonLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD5EAFF)),
      ),
      child: const Text(
        'Soon',
        style: TextStyle(
          color: Color(0xFF0878F9),
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
