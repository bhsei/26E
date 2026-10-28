import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:de_glitch/services/language_controller.dart';
import 'package:de_glitch/l10n/app_localizations.dart';

/// DēGlitch Profile & Settings screen.
///
/// IMPORTANT: pass [onLocaleChanged] from the app-level LocaleController.
/// That lets Flutter rebuild every screen with the selected language and saves
/// the choice across app restarts. A screen-local String change is not sufficient.
class SuperMobileProfile extends StatefulWidget {
  const SuperMobileProfile({
    super.key,
    this.displayName = 'Elijah Fullah',
    this.email = 'elijah@example.com',
    this.planName = 'Premium',
    this.avatarAsset = 'assets/images/pic.jpeg',
    this.initialLanguage = 'English',
    this.onLanguageChanged,
    this.onLocaleChanged,
    this.onAccountInformation,
    this.onActivityPreferences,
    this.onNetworkProfiles,
    this.onSecurityPrivacy,
    this.onHelpSupport,
    this.onAbout,
    this.onLogout,
  });

  final String displayName;
  final String email;
  final String planName;
  final String avatarAsset;
  final String
  initialLanguage; // Kept for source compatibility with the previous widget API.
  final ValueChanged<String>?
  onLanguageChanged; // Legacy callback; use onLocaleChanged for app-wide localization.
  final Future<void> Function(Locale locale)? onLocaleChanged;
  final VoidCallback? onAccountInformation;
  final VoidCallback? onActivityPreferences;
  final VoidCallback? onNetworkProfiles;
  final VoidCallback? onSecurityPrivacy;
  final VoidCallback? onHelpSupport;
  final VoidCallback? onAbout;
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

  Future<void> _chooseLanguage(AppLocalizations l) async {
    final current = Localizations.localeOf(context);
    final selected = await showModalBottomSheet<Locale>(
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
              Text(
                l.chooseLanguage,
                style: const TextStyle(
                  color: _deepBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              ...LanguageController.supportedLocales.map((locale) {
                final isSelected =
                    LanguageController.localeTag(locale) ==
                    LanguageController.localeTag(current);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    LanguageController.languageLabel(locale),
                    style: const TextStyle(
                      color: _deepBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: _blue)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(locale),
                );
              }),
              const SizedBox(height: 6),
              Text(
                l.languageRestartNote,
                style: const TextStyle(color: _mutedBlue, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected == null || !mounted) return;
    if (widget.onLocaleChanged == null) {
      _showMessage(l.languageChangeNotConfigured);
      return;
    }

    try {
      await widget.onLocaleChanged!(selected);
      widget.onLanguageChanged?.call(
        LanguageController.languageLabel(selected),
      );
      // LocaleController updates the root locale immediately and persists it.
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showMessage(AppLocalizations.of(context).languageSaved);
        });
      }
    } catch (_) {
      if (mounted) _showMessage(l.errorTryAgain);
    }
  }

  void _navigate(VoidCallback? callback, String routeName) {
    if (callback != null) {
      callback();
    } else {
      context.goNamed(routeName);
    }
  }

  Future<void> _confirmLogout(AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l.logOutQuestion),
        content: Text(l.logoutPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: _red),
            child: Text(l.logOut),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    if (widget.onLogout != null) {
      widget.onLogout!();
    } else {
      _showMessage(l.errorTryAgain);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currentLanguage = LanguageController.languageLabel(
      Localizations.localeOf(context),
    );

    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l.profileAndSettings,
          style: const TextStyle(
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
            _buildProfileCard(l),
            const SizedBox(height: 12),
            _SettingsRow(
              icon: Icons.person_outline_rounded,
              title: l.accountInformation,
              onTap: () => _navigate(
                widget.onAccountInformation,
                'super-mobile-account-information',
              ),
            ),
            _SettingsRow(
              icon: Icons.language_rounded,
              title: l.language,
              trailingText: currentLanguage,
              onTap: () => _chooseLanguage(l),
            ),
            _SettingsRow(
              icon: Icons.sports_esports_outlined,
              title: l.activityPreferences,
              onTap: () => _navigate(
                widget.onActivityPreferences,
                'super-mobile-activity-preferences',
              ),
            ),
            _SettingsRow(
              icon: Icons.settings_ethernet_rounded,
              title: l.networkProfiles,
              onTap: () => _navigate(
                widget.onNetworkProfiles,
                'super-mobile-network-profiles',
              ),
            ),
            _SettingsRow(
              icon: Icons.shield_outlined,
              title: l.securityAndPrivacy,
              onTap: () => _navigate(
                widget.onSecurityPrivacy,
                'super-mobile-security-privacy',
              ),
            ),
            _SettingsRow(
              icon: Icons.help_outline_rounded,
              title: l.helpAndSupport,
              onTap: () =>
                  _navigate(widget.onHelpSupport, 'super-mobile-help-support'),
            ),
            _SettingsRow(
              icon: Icons.info_outline_rounded,
              title: l.aboutDeGlitch,
              onTap: () =>
                  _navigate(widget.onAbout, 'super-mobile-about-deglitch'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => _confirmLogout(l),
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
                child: Text(l.logOut),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppLocalizations l) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
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
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _mutedBlue,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
