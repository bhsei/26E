import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_settings_components.dart';
import 'package:flutter/material.dart';

@immutable
class DgNetworkProfile {
  const DgNetworkProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.activity,
    required this.networkType,
    required this.icon,
    this.isDefault = false,
  });

  final String id;
  final String name;
  final String description;
  final String activity;
  final String networkType;
  final IconData icon;
  final bool isDefault;

  DgNetworkProfile copyWith({
    String? name,
    String? description,
    String? activity,
    String? networkType,
    IconData? icon,
    bool? isDefault,
  }) => DgNetworkProfile(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    activity: activity ?? this.activity,
    networkType: networkType ?? this.networkType,
    icon: icon ?? this.icon,
    isDefault: isDefault ?? this.isDefault,
  );
}

/// Manage named connection preference profiles. Profiles store preferences only;
/// applying one does not create or select a real endpoint unless callbacks do so.
class SuperMobileNetworkProfiles extends StatefulWidget {
  const SuperMobileNetworkProfiles({
    super.key,
    this.profiles,
    this.onProfilesChanged,
    this.onProfileSelected,
  });

  final List<DgNetworkProfile>? profiles;
  final ValueChanged<List<DgNetworkProfile>>? onProfilesChanged;
  final ValueChanged<DgNetworkProfile>? onProfileSelected;

  @override
  State<SuperMobileNetworkProfiles> createState() =>
      _SuperMobileNetworkProfilesState();
}

class _SuperMobileNetworkProfilesState
    extends State<SuperMobileNetworkProfiles> {
  late List<DgNetworkProfile> _profiles;
  String? _activeId;
  bool _isPreview = true;

  @override
  void initState() {
    super.initState();
    _isPreview = widget.profiles == null;
    _profiles = List<DgNetworkProfile>.of(
      widget.profiles ?? _previewProfiles(),
    );
    _activeId = _profiles.isEmpty
        ? null
        : _profiles
              .firstWhere((p) => p.isDefault, orElse: () => _profiles.first)
              .id;
  }

  @override
  void didUpdateWidget(covariant SuperMobileNetworkProfiles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profiles != oldWidget.profiles && widget.profiles != null) {
      _isPreview = false;
      _profiles = List<DgNetworkProfile>.of(widget.profiles!);
      if (!_profiles.any((p) => p.id == _activeId))
        _activeId = _profiles.isEmpty ? null : _profiles.first.id;
    }
  }

  List<DgNetworkProfile> _previewProfiles() => const [
    DgNetworkProfile(
      id: 'home',
      name: 'Home',
      description: 'Wi-Fi · Performance',
      activity: 'Browsing',
      networkType: 'Wi-Fi',
      icon: Icons.home_rounded,
      isDefault: true,
    ),
    DgNetworkProfile(
      id: 'university',
      name: 'University',
      description: 'Campus Wi-Fi · Reliability',
      activity: 'Studying',
      networkType: 'Wi-Fi',
      icon: Icons.school_rounded,
    ),
    DgNetworkProfile(
      id: 'mobile',
      name: 'Mobile Data',
      description: '3G/4G/5G · Data efficient',
      activity: 'Browsing',
      networkType: 'Mobile data',
      icon: Icons.signal_cellular_alt_rounded,
    ),
    DgNetworkProfile(
      id: 'travel',
      name: 'Travel',
      description: 'Roaming · Stability',
      activity: 'Travel',
      networkType: 'Any available',
      icon: Icons.flight_takeoff_rounded,
    ),
    DgNetworkProfile(
      id: 'gaming',
      name: 'Gaming',
      description: 'Low latency · High performance',
      activity: 'Gaming',
      networkType: 'Any available',
      icon: Icons.sports_esports_rounded,
    ),
  ];

  void _notifyChanged() =>
      widget.onProfilesChanged?.call(List.unmodifiable(_profiles));

  Future<void> _createOrEdit({DgNetworkProfile? profile}) async {
    final name = TextEditingController(text: profile?.name ?? '');
    final description = TextEditingController(text: profile?.description ?? '');
    var activity = profile?.activity ?? 'Browsing';
    var networkType = profile?.networkType ?? 'Any available';
    var icon = profile?.icon ?? Icons.tune_rounded;
    final result = await showModalBottomSheet<DgNetworkProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: DgColors.line,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      profile == null
                          ? 'Create network profile'
                          : 'Edit network profile',
                      style: const TextStyle(
                        color: DgColors.deepBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ProfileInput(controller: name, label: 'Profile name'),
                    const SizedBox(height: 12),
                    _ProfileInput(
                      controller: description,
                      label: 'Short description',
                    ),
                    const SizedBox(height: 12),
                    _ProfileDropdown<String>(
                      label: 'Activity',
                      value: activity,
                      values: const [
                        'Gaming',
                        'Video Call',
                        'Streaming',
                        'Studying',
                        'Development',
                        'Browsing',
                        'Travel',
                        'Custom',
                      ],
                      onChanged: (v) => setSheetState(() => activity = v),
                    ),
                    const SizedBox(height: 12),
                    _ProfileDropdown<String>(
                      label: 'Network preference',
                      value: networkType,
                      values: const ['Any available', 'Wi-Fi', 'Mobile data'],
                      onChanged: (v) => setSheetState(() => networkType = v),
                    ),
                    const SizedBox(height: 18),
                    DgPrimaryButton(
                      label: profile == null
                          ? 'Create profile'
                          : 'Save profile',
                      icon: Icons.check_rounded,
                      onPressed: () {
                        if (name.text.trim().isEmpty) {
                          dgShowMessage(sheetContext, 'Enter a profile name.');
                          return;
                        }
                        Navigator.of(sheetContext).pop(
                          DgNetworkProfile(
                            id:
                                profile?.id ??
                                'custom-${DateTime.now().microsecondsSinceEpoch}',
                            name: name.text.trim(),
                            description: description.text.trim().isEmpty
                                ? '$networkType · $activity'
                                : description.text.trim(),
                            activity: activity,
                            networkType: networkType,
                            icon: icon,
                            isDefault: profile?.isDefault ?? false,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    name.dispose();
    description.dispose();
    if (result == null || !mounted) return;
    setState(() {
      final index = _profiles.indexWhere((p) => p.id == result.id);
      if (index >= 0) {
        _profiles[index] = result;
      } else {
        _profiles.add(result);
      }
    });
    _notifyChanged();
    dgShowMessage(
      context,
      profile == null ? 'Profile added to this screen.' : 'Profile updated.',
    );
  }

  Future<void> _delete(DgNetworkProfile profile) async {
    if (profile.isDefault && _profiles.length > 1) {
      dgShowMessage(
        context,
        'Choose another default profile before deleting this one.',
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete profile?'),
        content: Text('Remove “${profile.name}” from the saved profile list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: DgColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() {
      _profiles.removeWhere((p) => p.id == profile.id);
      if (_activeId == profile.id)
        _activeId = _profiles.isEmpty ? null : _profiles.first.id;
    });
    _notifyChanged();
  }

  Future<void> _makeDefault(DgNetworkProfile profile) async {
    setState(() {
      _profiles = _profiles
          .map((p) => p.copyWith(isDefault: p.id == profile.id))
          .toList();
      _activeId = profile.id;
    });
    _notifyChanged();
    dgShowMessage(context, '${profile.name} is now the default profile.');
  }

  void _apply(DgNetworkProfile profile) {
    setState(() => _activeId = profile.id);
    widget.onProfileSelected?.call(profile);
    dgShowMessage(
      context,
      widget.onProfileSelected == null
          ? '${profile.name} selected. Connect a profile service to apply it to connectivity.'
          : '${profile.name} selected.',
    );
  }

  void _useSelected() {
    DgNetworkProfile? selected;
    for (final profile in _profiles) {
      if (profile.id == _activeId) {
        selected = profile;
        break;
      }
    }
    if (selected != null) _apply(selected);
  }

  @override
  Widget build(BuildContext context) => DgPageScaffold(
    title: 'Network Profiles',
    actions: [
      IconButton(
        tooltip: 'Add profile',
        onPressed: () => _createOrEdit(),
        icon: const Icon(Icons.add_rounded, color: DgColors.deepBlue),
      ),
    ],
    child: Column(
      children: [
        const SizedBox(height: 8),
        DgPanel(
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: DgColors.paleBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.settings_ethernet_rounded,
                  color: DgColors.blue,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection profiles',
                      style: TextStyle(
                        color: DgColors.deepBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Save preference presets for different places and activities.',
                      style: TextStyle(
                        color: DgColors.mutedBlue,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              DgStatusPill(
                '${_profiles.length} profiles',
                color: DgColors.blue,
              ),
            ],
          ),
        ),
        if (_isPreview)
          const Padding(
            padding: EdgeInsets.only(top: 9),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preview profiles · connect local persistence to retain changes',
                style: TextStyle(color: DgColors.mutedBlue, fontSize: 11),
              ),
            ),
          ),
        const DgSectionHeading(
          'Saved profiles',
          trailing: Text(
            'Tap to select',
            style: TextStyle(color: DgColors.mutedBlue, fontSize: 11),
          ),
        ),
        Expanded(
          child: _profiles.isEmpty
              ? DgEmptyState(
                  icon: Icons.layers_clear_rounded,
                  title: 'No profiles yet',
                  message:
                      'Create a profile to save your preferred activity and network settings.',
                  action: DgOutlineButton(
                    label: 'Create profile',
                    icon: Icons.add_rounded,
                    onPressed: () => _createOrEdit(),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 14),
                  itemCount: _profiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final profile = _profiles[index];
                    final active = profile.id == _activeId;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: active ? DgColors.blue : DgColors.line,
                          width: active ? 1.4 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => _apply(profile),
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: active
                                          ? DgColors.blue
                                          : DgColors.paleBlue,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      profile.icon,
                                      color: active
                                          ? Colors.white
                                          : DgColors.blue,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                profile.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: DgColors.deepBlue,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            if (profile.isDefault) ...[
                                              const SizedBox(width: 7),
                                              const DgStatusPill(
                                                'DEFAULT',
                                                color: DgColors.green,
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          profile.description,
                                          style: const TextStyle(
                                            color: DgColors.mutedBlue,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${profile.activity} · ${profile.networkType}',
                                          style: const TextStyle(
                                            color: DgColors.deepBlue,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    active
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: active
                                        ? DgColors.blue
                                        : DgColors.mutedBlue,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 1, color: DgColors.line),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            child: Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _makeDefault(profile),
                                  icon: const Icon(
                                    Icons.push_pin_outlined,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Set default',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Edit profile',
                                  onPressed: () =>
                                      _createOrEdit(profile: profile),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 19,
                                    color: DgColors.mutedBlue,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Delete profile',
                                  onPressed: () => _delete(profile),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 20,
                                    color: DgColors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        DgPrimaryButton(
          label: 'Use selected profile',
          icon: Icons.check_rounded,
          onPressed: _activeId == null ? null : _useSelected,
        ),
        const SizedBox(height: 4),
      ],
    ),
  );
}

class _ProfileInput extends StatelessWidget {
  const _ProfileInput({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: DgColors.page,
      labelStyle: const TextStyle(color: DgColors.mutedBlue, fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: DgColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: DgColors.line),
      ),
    ),
  );
}

class _ProfileDropdown<T> extends StatelessWidget {
  const _ProfileDropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });
  final String label;
  final T value;
  final List<T> values;
  final ValueChanged<T> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: DgColors.page,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: DgColors.line),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        hint: Text(label),
        items: values
            .map(
              (v) => DropdownMenuItem<T>(
                value: v,
                child: Text('$v', style: const TextStyle(fontSize: 13)),
              ),
            )
            .toList(),
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
      ),
    ),
  );
}
