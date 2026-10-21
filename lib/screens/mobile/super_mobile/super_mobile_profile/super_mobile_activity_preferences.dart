import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_settings_components.dart';
import 'package:flutter/material.dart';


@immutable
class ActivityPreferencesData {
  const ActivityPreferencesData({
    required this.activity,
    required this.preferLowLatency,
    required this.preferStability,
    required this.allowBackgroundChecks,
    required this.adaptiveRecommendations,
  });

  final String activity;
  final bool preferLowLatency;
  final bool preferStability;
  final bool allowBackgroundChecks;
  final bool adaptiveRecommendations;
}

class _ActivityOption {
  const _ActivityOption(this.name, this.subtitle, this.icon, this.hint);
  final String name;
  final String subtitle;
  final IconData icon;
  final String hint;
}

/// Activity profiles let users express priorities. They do not change routing
/// until the recommendation service is connected to [onSave].
class SuperMobileActivityPreferences extends StatefulWidget {
  const SuperMobileActivityPreferences({
    super.key,
    this.initialActivity = 'Gaming',
    this.initialPreferLowLatency = true,
    this.initialPreferStability = true,
    this.initialAllowBackgroundChecks = false,
    this.initialAdaptiveRecommendations = true,
    this.onSave,
  });

  final String initialActivity;
  final bool initialPreferLowLatency;
  final bool initialPreferStability;
  final bool initialAllowBackgroundChecks;
  final bool initialAdaptiveRecommendations;
  final Future<void> Function(ActivityPreferencesData data)? onSave;

  @override
  State<SuperMobileActivityPreferences> createState() => _SuperMobileActivityPreferencesState();
}

class _SuperMobileActivityPreferencesState extends State<SuperMobileActivityPreferences> {
  static const _options = <_ActivityOption>[
    _ActivityOption('Gaming', 'Low latency · Low jitter', Icons.sports_esports_rounded, 'Prioritize responsive connections for online play.'),
    _ActivityOption('Video Call', 'Stability · Low packet loss', Icons.video_call_rounded, 'Prefer consistent quality for meetings and calls.'),
    _ActivityOption('Streaming', 'Bandwidth · Stability', Icons.play_circle_outline_rounded, 'Balance throughput and stable playback.'),
    _ActivityOption('Studying', 'Stable · Low latency', Icons.menu_book_rounded, 'Support learning platforms and research sessions.'),
    _ActivityOption('Development', 'Reliable connection', Icons.code_rounded, 'Favor reliable access to development tools.'),
    _ActivityOption('Browsing', 'Balanced · Data efficient', Icons.public_rounded, 'Use a balanced profile for everyday browsing.'),
    _ActivityOption('Travel', 'Roaming · Stability', Icons.flight_takeoff_rounded, 'Favor predictable connectivity while moving.'),
  ];

  late String _activity;
  late bool _lowLatency;
  late bool _stability;
  late bool _backgroundChecks;
  late bool _adaptive;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _activity = _options.any((o) => o.name == widget.initialActivity) ? widget.initialActivity : 'Browsing';
    _lowLatency = widget.initialPreferLowLatency;
    _stability = widget.initialPreferStability;
    _backgroundChecks = widget.initialAllowBackgroundChecks;
    _adaptive = widget.initialAdaptiveRecommendations;
  }

  Future<void> _save() async {
    final data = ActivityPreferencesData(
      activity: _activity,
      preferLowLatency: _lowLatency,
      preferStability: _stability,
      allowBackgroundChecks: _backgroundChecks,
      adaptiveRecommendations: _adaptive,
    );
    setState(() => _saving = true);
    try {
      await widget.onSave?.call(data);
      if (mounted) dgShowMessage(context, widget.onSave == null ? 'Preferences ready. Connect the recommendation service to apply them.' : 'Activity preferences saved.');
    } catch (error) {
      if (mounted) dgShowMessage(context, 'Could not save preferences: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DgPageScaffold(
      title: 'Activity Preferences',
      child: ListView(
        children: [
          const SizedBox(height: 8),
          const DgPanel(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.tune_rounded, color: DgColors.blue, size: 28),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Choose your activity', style: TextStyle(color: DgColors.deepBlue, fontSize: 16, fontWeight: FontWeight.w800)),
                  SizedBox(height: 5),
                  Text('Each profile expresses different connection priorities. DēGlitch can use these preferences when its recommendation service is connected.', style: TextStyle(color: DgColors.mutedBlue, fontSize: 12, height: 1.4)),
                ])),
              ],
            ),
          ),
          const DgSectionHeading('Activity profile'),
          ..._options.map(_buildOption),
          const DgSectionHeading('Connection priorities'),
          DgPanel(
            padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
            child: Column(children: [
              _PreferenceSwitch(icon: Icons.speed_rounded, title: 'Prefer low latency', subtitle: 'Give response time higher weight', value: _lowLatency, onChanged: (v) => setState(() => _lowLatency = v)),
              const Divider(height: 1, color: DgColors.line),
              _PreferenceSwitch(icon: Icons.shield_moon_outlined, title: 'Prefer stability', subtitle: 'Give consistency and low loss higher weight', value: _stability, onChanged: (v) => setState(() => _stability = v)),
              const Divider(height: 1, color: DgColors.line),
              _PreferenceSwitch(icon: Icons.auto_awesome_rounded, title: 'Adaptive recommendations', subtitle: 'Allow suggestions to reflect this profile', value: _adaptive, onChanged: (v) => setState(() => _adaptive = v)),
              const Divider(height: 1, color: DgColors.line),
              _PreferenceSwitch(icon: Icons.sync_rounded, title: 'Background checks', subtitle: 'Permit non-essential periodic checks', value: _backgroundChecks, onChanged: (v) => setState(() => _backgroundChecks = v)),
            ]),
          ),
          const SizedBox(height: 18),
          DgPrimaryButton(label: 'Save preferences', icon: Icons.check_rounded, isLoading: _saving, onPressed: _save),
          const SizedBox(height: 8),
          const Text('These controls update the screen state. Actual routing or monitoring behavior requires service integration.', textAlign: TextAlign.center, style: TextStyle(color: DgColors.mutedBlue, fontSize: 11, height: 1.35)),
        ],
      ),
    );
  }

  Widget _buildOption(_ActivityOption option) {
    final selected = _activity == option.name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: selected ? const Color(0xFFE9F5FF) : Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => setState(() => _activity = option.name),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), border: Border.all(color: selected ? DgColors.blue : DgColors.line, width: selected ? 1.4 : 1)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: selected ? DgColors.blue : DgColors.paleBlue, borderRadius: BorderRadius.circular(13)), child: Icon(option.icon, color: selected ? Colors.white : DgColors.blue, size: 23)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(option.name, style: const TextStyle(color: DgColors.deepBlue, fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 3),
                Text(option.subtitle, style: const TextStyle(color: DgColors.mutedBlue, fontSize: 12)),
                if (selected) ...[const SizedBox(height: 5), Text(option.hint, style: const TextStyle(color: DgColors.deepBlue, fontSize: 11, height: 1.3))],
              ])),
              Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? DgColors.blue : DgColors.mutedBlue, size: 22),
            ]),
          ),
        ),
      ),
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  const _PreferenceSwitch({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(icon, color: DgColors.blue, size: 23),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: DgColors.deepBlue, fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(color: DgColors.mutedBlue, fontSize: 11, height: 1.25))])),
          Switch.adaptive(value: value, onChanged: onChanged, activeColor: DgColors.blue),
        ]),
      );
}
