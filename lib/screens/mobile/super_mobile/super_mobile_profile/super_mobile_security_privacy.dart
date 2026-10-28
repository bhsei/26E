import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_settings_components.dart';
import 'package:flutter/material.dart';

@immutable
class SecurityPrivacySettings {
  const SecurityPrivacySettings({
    required this.killSwitch,
    required this.secureDns,
    required this.minimizeDiagnostics,
    required this.clearHistoryAfterThirtyDays,
  });

  final bool killSwitch;
  final bool secureDns;
  final bool minimizeDiagnostics;
  final bool clearHistoryAfterThirtyDays;
}

/// Privacy controls UI. Switches update local state and emit [onChanged];
/// connect them to supported platform services before implying enforcement.
class SuperMobileSecurityPrivacy extends StatefulWidget {
  const SuperMobileSecurityPrivacy({
    super.key,
    this.initialKillSwitch = false,
    this.initialSecureDns = true,
    this.initialMinimizeDiagnostics = true,
    this.initialClearHistoryAfterThirtyDays = false,
    this.onChanged,
    this.onManagePermissions,
    this.onViewPrivacyDetails,
    this.onExportData,
  });

  final bool initialKillSwitch;
  final bool initialSecureDns;
  final bool initialMinimizeDiagnostics;
  final bool initialClearHistoryAfterThirtyDays;
  final ValueChanged<SecurityPrivacySettings>? onChanged;
  final VoidCallback? onManagePermissions;
  final VoidCallback? onViewPrivacyDetails;
  final VoidCallback? onExportData;

  @override
  State<SuperMobileSecurityPrivacy> createState() =>
      _SuperMobileSecurityPrivacyState();
}

class _SuperMobileSecurityPrivacyState
    extends State<SuperMobileSecurityPrivacy> {
  late bool _killSwitch;
  late bool _secureDns;
  late bool _minimizeDiagnostics;
  late bool _clearHistory;

  @override
  void initState() {
    super.initState();
    _killSwitch = widget.initialKillSwitch;
    _secureDns = widget.initialSecureDns;
    _minimizeDiagnostics = widget.initialMinimizeDiagnostics;
    _clearHistory = widget.initialClearHistoryAfterThirtyDays;
  }

  void _emit() => widget.onChanged?.call(
    SecurityPrivacySettings(
      killSwitch: _killSwitch,
      secureDns: _secureDns,
      minimizeDiagnostics: _minimizeDiagnostics,
      clearHistoryAfterThirtyDays: _clearHistory,
    ),
  );

  void _toggle(String label, bool value, ValueChanged<bool> setter) {
    setState(() => setter(value));
    _emit();
    if (widget.onChanged == null) {
      dgShowMessage(
        context,
        '$label updated for this screen. Connect the platform service to enforce it.',
      );
    }
  }

  void _open(String title, VoidCallback? callback) {
    if (callback != null) {
      callback();
    } else {
      dgShowMessage(context, '$title is ready to connect to the app service.');
    }
  }

  @override
  Widget build(BuildContext context) => DgPageScaffold(
    title: 'Security & Privacy',
    child: ListView(
      children: [
        const SizedBox(height: 8),
        DgPanel(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: DgColors.paleBlue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: DgColors.blue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your privacy, your control',
                      style: TextStyle(
                        color: DgColors.deepBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Choose what DēGlitch should retain and review security controls available on your platform.',
                      style: TextStyle(
                        color: DgColors.mutedBlue,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const DgSectionHeading('Connection protection'),
        DgPanel(
          padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
          child: Column(
            children: [
              _SecuritySwitch(
                icon: Icons.power_settings_new_rounded,
                title: 'Kill switch',
                subtitle: 'Block traffic if the tunnel drops, where supported',
                value: _killSwitch,
                onChanged: (v) =>
                    _toggle('Kill switch', v, (b) => _killSwitch = b),
              ),
              const Divider(height: 1, color: DgColors.line),
              _SecuritySwitch(
                icon: Icons.dns_outlined,
                title: 'Secure DNS preference',
                subtitle: 'Prefer configured DNS protection when supported',
                value: _secureDns,
                onChanged: (v) =>
                    _toggle('Secure DNS preference', v, (b) => _secureDns = b),
              ),
            ],
          ),
        ),
        const DgSectionHeading('Data and diagnostics'),
        DgPanel(
          padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
          child: Column(
            children: [
              _SecuritySwitch(
                icon: Icons.visibility_off_outlined,
                title: 'Minimize diagnostic data',
                subtitle:
                    'Avoid collecting browsing content or unnecessary personal data',
                value: _minimizeDiagnostics,
                onChanged: (v) => _toggle(
                  'Diagnostic data preference',
                  v,
                  (b) => _minimizeDiagnostics = b,
                ),
              ),
              const Divider(height: 1, color: DgColors.line),
              _SecuritySwitch(
                icon: Icons.auto_delete_outlined,
                title: 'Clear history after 30 days',
                subtitle: 'Preference only until storage cleanup is integrated',
                value: _clearHistory,
                onChanged: (v) => _toggle(
                  'History retention preference',
                  v,
                  (b) => _clearHistory = b,
                ),
              ),
            ],
          ),
        ),
        const DgSectionHeading('Your data'),
        DgPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              DgSettingsTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'App permissions',
                subtitle: 'Review permissions requested by your device',
                onTap: () =>
                    _open('App permissions', widget.onManagePermissions),
              ),
              const Divider(height: 1, color: DgColors.line, indent: 64),
              DgSettingsTile(
                icon: Icons.policy_outlined,
                title: 'Privacy details',
                subtitle: 'What is collected and why',
                onTap: () =>
                    _open('Privacy details', widget.onViewPrivacyDetails),
              ),
              const Divider(height: 1, color: DgColors.line, indent: 64),
              DgSettingsTile(
                icon: Icons.file_download_outlined,
                title: 'Export my data',
                subtitle: 'Prepare a copy of available locally stored data',
                onTap: () => _open('Export my data', widget.onExportData),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6E6),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFF5DDAA)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: DgColors.amber, size: 20),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Availability depends on operating-system APIs and the selected connectivity implementation. These controls do not enforce protection until connected to platform services.',
                  style: TextStyle(
                    color: Color(0xFF79521A),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SecuritySwitch extends StatelessWidget {
  const _SecuritySwitch({
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 11),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: DgColors.paleBlue,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: DgColors.blue, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: DgColors.deepBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: DgColors.mutedBlue,
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeColor: DgColors.blue,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}
