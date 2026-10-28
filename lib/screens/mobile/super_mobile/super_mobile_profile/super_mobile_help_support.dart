import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_settings_components.dart';
import 'package:flutter/material.dart';

@immutable
class DgHelpTopic {
  const DgHelpTopic({
    required this.question,
    required this.answer,
    this.category = 'Getting started',
  });
  final String question;
  final String answer;
  final String category;
}

class SuperMobileHelpSupport extends StatefulWidget {
  const SuperMobileHelpSupport({
    super.key,
    this.appVersion = '1.1',
    this.onContactSupport,
    this.onReportIssue,
    this.onRunDiagnostics,
    this.topics = const [],
  });

  final String appVersion;
  final VoidCallback? onContactSupport;
  final VoidCallback? onReportIssue;
  final VoidCallback? onRunDiagnostics;
  final List<DgHelpTopic> topics;

  @override
  State<SuperMobileHelpSupport> createState() => _SuperMobileHelpSupportState();
}

class _SuperMobileHelpSupportState extends State<SuperMobileHelpSupport> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'All';
  late List<DgHelpTopic> _topics;

  @override
  void initState() {
    super.initState();
    _topics = widget.topics.isEmpty ? _defaultTopics : widget.topics;
    _searchController.addListener(
      () =>
          setState(() => _query = _searchController.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DgHelpTopic> get _visibleTopics => _topics.where((topic) {
    final matchesQuery =
        _query.isEmpty ||
        topic.question.toLowerCase().contains(_query) ||
        topic.answer.toLowerCase().contains(_query);
    final matchesCategory = _category == 'All' || topic.category == _category;
    return matchesQuery && matchesCategory;
  }).toList();

  static const _defaultTopics = <DgHelpTopic>[
    DgHelpTopic(
      question: 'How do I connect?',
      answer:
          'Open Home, import or select a supported local profile, then use the connection control. Follow any operating-system permission prompt. The status should reflect the underlying connection service.',
      category: 'Connection',
    ),
    DgHelpTopic(
      question: 'Why is my connection slow?',
      answer:
          'Run Diagnostics and review the measurements available on your device. Try another eligible endpoint only when its profile is configured, and compare results under similar network conditions.',
      category: 'Connection',
    ),
    DgHelpTopic(
      question: 'What does Lite Mode do?',
      answer:
          'Lite Mode is intended to reduce non-essential background work on constrained networks or devices. Its actual effect depends on which background tasks are enabled in the implementation.',
      category: 'Features',
    ),
    DgHelpTopic(
      question: 'How do I change my activity profile?',
      answer:
          'Open Profile & Settings or More, select Activity Preferences, choose an activity such as Gaming, Video Call, Streaming, Studying or Browsing, and save your preference.',
      category: 'Features',
    ),
    DgHelpTopic(
      question: 'Where can I review past connections?',
      answer:
          'Open View Connection History to see the sessions recorded by the app. Session history is only available for periods and fields that have been saved by the configured history service.',
      category: 'Account & data',
    ),
    DgHelpTopic(
      question: 'How is my data handled?',
      answer:
          'Review Security & Privacy for available controls. The app should avoid storing secrets or unnecessary browsing content, and data retention depends on the storage features enabled.',
      category: 'Account & data',
    ),
  ];

  void _open(String label, VoidCallback? callback) {
    if (callback != null)
      callback();
    else
      dgShowMessage(
        context,
        '$label will be available when the support flow is connected.',
      );
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>[
      'All',
      'Connection',
      'Features',
      'Account & data',
    ];
    return DgPageScaffold(
      title: 'Help & Support',
      child: ListView(
        children: [
          const SizedBox(height: 8),
          DgPanel(
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: DgColors.paleBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: DgColors.blue,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How can we help?',
                        style: TextStyle(
                          color: DgColors.deepBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Find answers or get help with your connection.',
                        style: TextStyle(
                          color: DgColors.mutedBlue,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const DgSectionHeading('Quick support'),
          Row(
            children: [
              Expanded(
                child: _SupportAction(
                  icon: Icons.speed_rounded,
                  title: 'Run diagnostics',
                  onTap: () => _open('Diagnostics', widget.onRunDiagnostics),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SupportAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Contact support',
                  onTap: () =>
                      _open('Contact support', widget.onContactSupport),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DgOutlineButton(
            label: 'Report a problem',
            icon: Icons.flag_outlined,
            foregroundColor: DgColors.deepBlue,
            onPressed: () => _open('Report a problem', widget.onReportIssue),
          ),
          const DgSectionHeading('Frequently asked questions'),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search help articles',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: DgColors.mutedBlue,
              ),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => _searchController.clear(),
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: DgColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: DgColors.line),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = _category == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _category = category;
                      });
                    },
                    selectedColor: DgColors.blue,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : DgColors.deepBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide(
                      color: isSelected ? DgColors.blue : DgColors.line,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          if (_visibleTopics.isEmpty)
            // Keep your existing empty-state widget here.
            const DgEmptyState(
              icon: Icons.search_off_rounded,
              title: 'No matching articles',
              message: 'Try another phrase or choose a different category.',
            )
          else
            DgPanel(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              child: Column(
                children: _visibleTopics
                    .asMap()
                    .entries
                    .map(
                      (entry) => Column(
                        children: [
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(
                              left: 2,
                              right: 2,
                              bottom: 14,
                            ),
                            iconColor: DgColors.blue,
                            collapsedIconColor: DgColors.mutedBlue,
                            title: Text(
                              entry.value.question,
                              style: const TextStyle(
                                color: DgColors.deepBlue,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  entry.value.answer,
                                  style: const TextStyle(
                                    color: DgColors.mutedBlue,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (entry.key != _visibleTopics.length - 1)
                            const Divider(height: 1, color: DgColors.line),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'DēGlitch v${widget.appVersion}',
              style: const TextStyle(color: DgColors.mutedBlue, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportAction extends StatelessWidget {
  const _SupportAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DgColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: DgColors.paleBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: DgColors.blue),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: DgColors.deepBlue,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Tap to open',
              style: TextStyle(color: DgColors.mutedBlue, fontSize: 11),
            ),
          ],
        ),
      ),
    ),
  );
}
