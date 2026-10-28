import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_settings_components.dart';
import 'package:flutter/material.dart';

/// About screen for product identity, version, key areas and policy destinations.
/// Platform names describe the intended product scope, not verified releases.
class SuperMobileAboutDeGlitch extends StatelessWidget {
  const SuperMobileAboutDeGlitch({
    super.key,
    this.appVersion = '1.1',
    this.buildNumber = 'Prototype',
    this.onPrivacyPolicy,
    this.onTermsOfUse,
    this.onOpenSourceLicenses,
    this.onWebsite,
  });

  final String appVersion;
  final String buildNumber;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTermsOfUse;
  final VoidCallback? onOpenSourceLicenses;
  final VoidCallback? onWebsite;

  void _open(BuildContext context, String title, VoidCallback? callback) {
    if (callback != null)
      callback();
    else
      dgShowMessage(
        context,
        '$title is ready to connect to your information page.',
      );
  }

  @override
  Widget build(BuildContext context) => DgPageScaffold(
    title: 'About DēGlitch',
    child: ListView(
      children: [
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 23),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A3A75), Color(0xFF0878F9)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'DēGlitch',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Smarter Connectivity. Safer Tomorrow.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD8EAFF),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Version $appVersion  ·  $buildNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const DgSectionHeading('Our purpose'),
        const DgPanel(
          child: Text(
            'DēGlitch is a context-aware adaptive connectivity project designed to help users understand connection quality and choose appropriate connectivity settings based on available network conditions, device constraints and activity preferences.',
            style: TextStyle(
              color: DgColors.deepBlue,
              fontSize: 13,
              height: 1.55,
            ),
          ),
        ),
        const DgSectionHeading('Core areas'),
        const _AboutFeature(
          icon: Icons.alt_route_rounded,
          title: 'Adaptive connectivity',
          subtitle:
              'Recommendations based on available context and measurements.',
        ),
        const SizedBox(height: 9),
        const _AboutFeature(
          icon: Icons.monitor_heart_outlined,
          title: 'Network health and diagnostics',
          subtitle: 'Connection indicators and guided troubleshooting.',
        ),
        const SizedBox(height: 9),
        const _AboutFeature(
          icon: Icons.person_pin_circle_outlined,
          title: 'Activity and network profiles',
          subtitle:
              'Preference presets for different activities and environments.',
        ),
        const SizedBox(height: 9),
        const _AboutFeature(
          icon: Icons.shield_outlined,
          title: 'Security and privacy controls',
          subtitle: 'User-facing controls designed around data minimization.',
        ),
        const DgSectionHeading('Intended platform scope'),
        DgPanel(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _PlatformChip(
                icon: Icons.phone_android_rounded,
                label: 'Android',
              ),
              _PlatformChip(icon: Icons.phone_iphone_rounded, label: 'iOS'),
              _PlatformChip(icon: Icons.laptop_mac_rounded, label: 'macOS'),
              _PlatformChip(icon: Icons.window_rounded, label: 'Windows'),
              _PlatformChip(icon: Icons.terminal_rounded, label: 'Linux'),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Platform availability depends on implementation and verification for each operating system.',
            style: TextStyle(
              color: DgColors.mutedBlue,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ),
        const DgSectionHeading('Information and policies'),
        DgPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              DgSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy policy',
                onTap: () => _open(context, 'Privacy policy', onPrivacyPolicy),
              ),
              const Divider(height: 1, color: DgColors.line, indent: 64),
              DgSettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of use',
                onTap: () => _open(context, 'Terms of use', onTermsOfUse),
              ),
              const Divider(height: 1, color: DgColors.line, indent: 64),
              DgSettingsTile(
                icon: Icons.code_rounded,
                title: 'Open-source licenses',
                onTap: () => _open(
                  context,
                  'Open-source licenses',
                  onOpenSourceLicenses,
                ),
              ),
              const Divider(height: 1, color: DgColors.line, indent: 64),
              DgSettingsTile(
                icon: Icons.public_rounded,
                title: 'DēGlitch project',
                onTap: () => _open(context, 'DēGlitch project', onWebsite),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Built as a software engineering project',
            style: TextStyle(color: DgColors.mutedBlue, fontSize: 11),
          ),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            '© DēGlitch',
            style: TextStyle(color: DgColors.mutedBlue, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}

class _AboutFeature extends StatelessWidget {
  const _AboutFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => DgPanel(
    padding: const EdgeInsets.all(13),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: DgColors.paleBlue,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: DgColors.blue, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: DgColors.deepBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: DgColors.mutedBlue,
                  fontSize: 11,
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

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: DgColors.paleBlue,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: DgColors.line),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: DgColors.blue),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: DgColors.deepBlue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
