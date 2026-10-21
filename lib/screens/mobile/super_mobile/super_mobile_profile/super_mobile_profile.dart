import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// DēGlitch Profile & Settings screen.
///
/// This screen provides the UI and callbacks for settings destinations. Connect
/// the callbacks to real routes/services in the app shell. It does not perform
/// authentication or modify device-level network settings by itself.
class SuperMobileProfile extends StatefulWidget {
  const SuperMobileProfile({
    super.key,
    this.displayName = 'Elijah Fullah',
    this.email = 'elijah@example.com',
    this.planName = 'Premium',
    this.avatarAsset = 'assets/images/pic.jpeg',
    this.initialLanguage = 'English',
    this.onAccountInformation,
    this.onActivityPreferences,
    this.onNetworkProfiles,
    this.onSecurityPrivacy,
    this.onHelpSupport,
    this.onAbout,
    this.onLanguageChanged,
    this.onLogout,
  });

  final String displayName;
  final String email;
  final String planName;
  final String avatarAsset;
  final String initialLanguage;

  final VoidCallback? onAccountInformation;
  final VoidCallback? onActivityPreferences;
  final VoidCallback? onNetworkProfiles;
  final VoidCallback? onSecurityPrivacy;
  final VoidCallback? onHelpSupport;
  final VoidCallback? onAbout;
  final ValueChanged<String>? onLanguageChanged;
  final VoidCallback? onLogout;

  @override
  State<SuperMobileProfile> createState() => _SuperMobileProfileState();
}

class _SuperMobileProfileState extends State<SuperMobileProfile> {
  static const Color _blue = Color(0xFF0878F9);
  static const Color _deepBlue = Color(0xFF12447F);
  static const Color _mutedBlue = Color(0xFF7193B7);
  static const Color _page = Color(0xFFF3F8FD);
  static const Color _line = Color(0xFFDDEBFA);
  static const Color _red = Color(0xFFE64F5A);

  late String _language;

  @override
  void initState() {
    super.initState();
    _language = widget.initialLanguage;
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

  void _openDestination(String title, VoidCallback? callback) {
    if (callback != null) {
      callback();
    } else {
      _showMessage('$title is not connected to a screen yet.');
    }
  }

  Future<void> _chooseLanguage() async {
    const languages = <String>['English', '简体中文', 'Krio', 'Russian', 'Français', 'Español'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E2ED),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Choose language',
                style: TextStyle(
                  color: _deepBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              ...languages.map(
                (language) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    language,
                    style: const TextStyle(
                      color: _deepBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: language == _language
                      ? const Icon(Icons.check_circle, color: _blue)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(language),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected == null || !mounted) return;
    setState(() => _language = selected);
    widget.onLanguageChanged?.call(selected);
    if (widget.onLanguageChanged == null) {
      _showMessage('Language selection updated for this screen only.');
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log out?'),
        content: const Text(
          'Are you sure you want to log out of DēGlitch?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: _red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    if (widget.onLogout != null) {
      widget.onLogout!();
    } else {
      _showMessage('Connect the Log Out action to your authentication flow.');
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
          'Profile & Settings',
          style: TextStyle(
            color: _deepBlue,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _buildProfileCard(),
            const SizedBox(height: 12),
            _SettingsRow(
              icon: Icons.person_outline_rounded,
              title: 'Account Information',
              onTap: () => context.goNamed('super-mobile-account-information'),
            ),
            _SettingsRow(
              icon: Icons.language_rounded,
              title: 'Language',
              trailingText: _language,
              onTap: _chooseLanguage,
            ),
            _SettingsRow(
              icon: Icons.sports_esports_outlined,
              title: 'Activity Preferences',
              onTap: () => context.goNamed('super-mobile-activity-preferences'),
            ),
            _SettingsRow(
              icon: Icons.settings_ethernet_rounded,
              title: 'Network Profiles',
              onTap: () => context.goNamed('super-mobile-network-profiles'),
            ),
            _SettingsRow(
              icon: Icons.shield_outlined,
              title: 'Security & Privacy',
              onTap: () => context.goNamed('super-mobile-security-privacy'),
            ),
            _SettingsRow(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              onTap: () => context.goNamed('super-mobile-help-support'),
            ),
            _SettingsRow(
              icon: Icons.info_outline_rounded,
              title: 'About DēGlitch',
              onTap: () => context.goNamed('super-mobile-about-deglitch'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: _confirmLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _red,
                  backgroundColor: const Color(0xFFFFF9FA),
                  side: const BorderSide(color: Color(0xFFFFD6DA), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2D75B7),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              widget.avatarAsset,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: const Color(0xFFE0F0FF),
                alignment: Alignment.center,
                child: const Icon(Icons.person, color: _blue, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _deepBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _mutedBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: _blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, color: Colors.white, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        widget.planName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
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
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  static const Color _deepBlue = Color(0xFF12447F);
  static const Color _mutedBlue = Color(0xFF7193B7);
  static const Color _line = Color(0xFFE0EDF9);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line.withValues(alpha: 0.75)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            child: Row(
              children: [
                Icon(icon, color: _deepBlue, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: _deepBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (trailingText != null) ...[
                  Text(
                    trailingText!,
                    style: const TextStyle(
                      color: _mutedBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Icon(Icons.chevron_right_rounded, color: _mutedBlue, size: 19),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
