import 'package:flutter/material.dart';

/// Outcome recorded for a completed or interrupted DēGlitch session.
enum ConnectionHistoryStatus { successful, issue }

/// A connection-history record suitable for mapping to local persistence later.
class ConnectionHistoryEntry {
  const ConnectionHistoryEntry({
    required this.id,
    required this.serverName,
    required this.country,
    required this.flag,
    required this.startedAt,
    required this.duration,
    required this.activity,
    required this.healthScore,
    required this.status,
    this.bytesReceived = 0,
    this.bytesSent = 0,
    this.note,
  });

  final String id;
  final String serverName;
  final String country;
  final String flag;
  final DateTime startedAt;
  final Duration duration;
  final String activity;
  final int healthScore;
  final ConnectionHistoryStatus status;
  final int bytesReceived;
  final int bytesSent;
  final String? note;
}

enum _HistoryFilter { all, successful, issues }

enum _HistoryRange { allTime, today, sevenDays, thirtyDays }

/// Connection History screen for DēGlitch.
///
/// When [entries] is omitted, the screen shows clearly labelled preview data.
/// Pass an empty list to show the real empty state, or pass persisted records
/// from the app's repository. Use [onClearHistory] to delete stored records.
class SuperMobileConnectionHistory extends StatefulWidget {
  const SuperMobileConnectionHistory({
    super.key,
    this.entries,
    this.onClearHistory,
    this.onSessionSelected,
  });

  final List<ConnectionHistoryEntry>? entries;
  final Future<void> Function()? onClearHistory;
  final ValueChanged<ConnectionHistoryEntry>? onSessionSelected;

  @override
  State<SuperMobileConnectionHistory> createState() =>
      _SuperMobileConnectionHistoryState();
}

class _SuperMobileConnectionHistoryState
    extends State<SuperMobileConnectionHistory> {
  static const Color _blue = Color(0xFF0878F9);
  static const Color _deepBlue = Color(0xFF12447F);
  static const Color _mutedBlue = Color(0xFF7093B9);
  static const Color _page = Color(0xFFF3F8FD);
  static const Color _line = Color(0xFFDCEBFA);
  static const Color _green = Color(0xFF10A879);
  static const Color _red = Color(0xFFE45C66);
  static const Color _amber = Color(0xFFE9A23B);

  late List<ConnectionHistoryEntry> _sessions;
  late bool _isPreviewData;
  _HistoryFilter _filter = _HistoryFilter.all;
  _HistoryRange _range = _HistoryRange.allTime;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    _isPreviewData = widget.entries == null;
    _sessions = List<ConnectionHistoryEntry>.of(
      widget.entries ?? _previewSessions(),
    );
  }

  @override
  void didUpdateWidget(covariant SuperMobileConnectionHistory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entries != oldWidget.entries && widget.entries != null) {
      _isPreviewData = false;
      _sessions = List<ConnectionHistoryEntry>.of(widget.entries!);
    }
  }

  List<ConnectionHistoryEntry> get _filteredSessions {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    return _sessions.where((session) {
      final matchesFilter = switch (_filter) {
        _HistoryFilter.all => true,
        _HistoryFilter.successful =>
          session.status == ConnectionHistoryStatus.successful,
        _HistoryFilter.issues =>
          session.status == ConnectionHistoryStatus.issue,
      };

      final matchesRange = switch (_range) {
        _HistoryRange.allTime => true,
        _HistoryRange.today => !session.startedAt.isBefore(startOfToday),
        _HistoryRange.sevenDays => !session.startedAt.isBefore(
          now.subtract(const Duration(days: 7)),
        ),
        _HistoryRange.thirtyDays => !session.startedAt.isBefore(
          now.subtract(const Duration(days: 30)),
        ),
      };
      return matchesFilter && matchesRange;
    }).toList()..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  int get _averageHealth {
    if (_sessions.isEmpty) return 0;
    return (_sessions.fold<int>(0, (sum, s) => sum + s.healthScore) /
            _sessions.length)
        .round();
  }

  Duration get _totalDuration => _sessions.fold<Duration>(
    Duration.zero,
    (total, session) => total + session.duration,
  );

  Future<void> _clearHistory() async {
    if (_sessions.isEmpty || _isClearing) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear connection history?'),
        content: Text(
          _isPreviewData
              ? 'This will clear the preview sessions from this screen.'
              : 'This will remove ${_sessions.length} saved session${_sessions.length == 1 ? '' : 's'}. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear history'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isClearing = true);
    try {
      await widget.onClearHistory?.call();
      if (!mounted) return;
      setState(() {
        _sessions.clear();
        _isPreviewData = false;
      });
      _showMessage('Connection history cleared.');
    } catch (error) {
      if (mounted) {
        _showMessage('Could not clear history. ${_shortError(error)}');
      }
    } finally {
      if (mounted) setState(() => _isClearing = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  String _shortError(Object error) {
    final value = error.toString().replaceFirst('Exception: ', '').trim();
    return value.length > 90 ? '${value.substring(0, 87)}...' : value;
  }

  void _openDetails(ConnectionHistoryEntry session) {
    widget.onSessionSelected?.call(session);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SessionDetailsSheet(
        session: session,
        deepBlue: _deepBlue,
        blue: _blue,
        green: _green,
        red: _red,
        line: _line,
        mutedBlue: _mutedBlue,
        isPreview: _isPreviewData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleSessions = _filteredSessions;
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: _deepBlue,
        ),
        title: const Text(
          'Connection History',
          style: TextStyle(
            color: _deepBlue,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear history',
            onPressed: _sessions.isEmpty || _isClearing ? null : _clearHistory,
            icon: _isClearing
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline_rounded),
            color: _deepBlue,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                children: [
                  if (_isPreviewData) ...[
                    /*_buildPreviewNotice(),*/
                    const SizedBox(height: 14),
                  ],
                  _buildSummary(),
                  const SizedBox(height: 20),
                  _buildOutcomeFilters(),
                  const SizedBox(height: 12),
                  _buildRangeFilter(),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Recent sessions',
                          style: TextStyle(
                            color: _deepBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${visibleSessions.length} session${visibleSessions.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: _mutedBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (visibleSessions.isEmpty)
                    _buildEmptyState()
                  else
                    ...visibleSessions.map(
                      (session) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildSessionCard(session),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildPreviewNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E5),
        border: Border.all(color: const Color(0xFFF6DCA9)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _amber, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Preview records — connect saved sessions to show real history.',
              style: TextStyle(
                color: Color(0xFF8A5A12),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE6F3FF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history_rounded, color: _blue, size: 21),
              SizedBox(width: 8),
              Text(
                'Your connections at a glance',
                style: TextStyle(
                  color: _deepBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _SummaryValue(
                  value: '${_sessions.length}',
                  label: 'Sessions',
                  icon: Icons.swap_vert_rounded,
                  color: _blue,
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _SummaryValue(
                  value: _sessions.isEmpty ? '—' : '$_averageHealth/100',
                  label: 'Avg. health',
                  icon: Icons.shield_outlined,
                  color: _green,
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _SummaryValue(
                  value: _sessions.isEmpty
                      ? '—'
                      : _formatDuration(_totalDuration),
                  label: 'Total time',
                  icon: Icons.schedule_rounded,
                  color: _mutedBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
    width: 1,
    height: 53,
    margin: const EdgeInsets.symmetric(horizontal: 3),
    color: _line,
  );

  Widget _buildOutcomeFilters() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1FC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _outcomeTab('All', _HistoryFilter.all),
          _outcomeTab('Successful', _HistoryFilter.successful),
          _outcomeTab('Issues', _HistoryFilter.issues),
        ],
      ),
    );
  }

  Widget _outcomeTab(String label, _HistoryFilter filter) {
    final selected = _filter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filter = filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
          decoration: BoxDecoration(
            color: selected ? _blue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : _mutedBlue,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRangeFilter() {
    const labels = ['All time', 'Today', '7 days', '30 days'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_HistoryRange.values.length, (index) {
          final range = _HistoryRange.values[index];
          final selected = _range == range;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _range = range),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFDCEEFF) : Colors.white,
                  border: Border.all(color: selected ? _blue : _line),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: selected ? _blue : _mutedBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSessionCard(ConnectionHistoryEntry session) {
    final isIssue = session.status == ConnectionHistoryStatus.issue;
    final statusColor = isIssue ? _red : _green;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openDetails(session),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      session.flag,
                      style: const TextStyle(fontSize: 23),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.serverName,
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
                          '${_dateLabel(session.startedAt)} · ${_clockLabel(session.startedAt)}',
                          style: const TextStyle(
                            color: _mutedBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.11),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isIssue ? 'Issue' : 'Success',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Container(height: 1, color: _line),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CompactMetric(
                      icon: Icons.timelapse_rounded,
                      label: 'Duration',
                      value: _formatDuration(session.duration),
                    ),
                  ),
                  Expanded(
                    child: _CompactMetric(
                      icon: Icons.sports_esports_rounded,
                      label: 'Activity',
                      value: session.activity,
                    ),
                  ),
                  Expanded(
                    child: _CompactMetric(
                      icon: Icons.shield_outlined,
                      label: 'Health',
                      value: '${session.healthScore}/100',
                      valueColor: _healthColor(session.healthScore),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: _mutedBlue,
                    size: 21,
                  ),
                ],
              ),
              if (isIssue && session.note != null) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: _red,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          session.note!,
                          style: const TextStyle(
                            color: Color(0xFF9C343C),
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasAnySessions = _sessions.isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 34, 22, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF5FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_rounded, color: _blue, size: 34),
          ),
          const SizedBox(height: 15),
          Text(
            hasAnySessions
                ? 'No matching sessions'
                : 'No connection history yet',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _deepBlue,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            hasAnySessions
                ? 'Try another status or date range to see more sessions.'
                : 'Your saved connection sessions will appear here after you connect.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _mutedBlue,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          if (hasAnySessions) ...[
            const SizedBox(height: 14),
            TextButton(
              onPressed: () => setState(() {
                _filter = _HistoryFilter.all;
                _range = _HistoryRange.allTime;
              }),
              child: const Text('Reset filters'),
            ),
          ],
        ],
      ),
    );
  }

  Color _healthColor(int score) {
    if (score >= 80) return _green;
    if (score >= 60) return _amber;
    return _red;
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _clockLabel(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      final remainderHours = duration.inHours % 24;
      return '${duration.inDays}d ${remainderHours}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }

  List<ConnectionHistoryEntry> _previewSessions() {
    final now = DateTime.now();
    return [
      ConnectionHistoryEntry(
        id: 'preview-1',
        serverName: 'Singapore-03',
        country: 'Singapore',
        flag: '🇸🇬',
        startedAt: now.subtract(const Duration(minutes: 34)),
        duration: const Duration(minutes: 24),
        activity: 'Gaming',
        healthScore: 87,
        status: ConnectionHistoryStatus.successful,
        bytesReceived: 52428800,
        bytesSent: 12582912,
      ),
      ConnectionHistoryEntry(
        id: 'preview-2',
        serverName: 'Hong Kong-01',
        country: 'Hong Kong',
        flag: '🇭🇰',
        startedAt: now.subtract(const Duration(hours: 3, minutes: 20)),
        duration: const Duration(hours: 1, minutes: 12),
        activity: 'Browsing',
        healthScore: 82,
        status: ConnectionHistoryStatus.successful,
        bytesReceived: 176160768,
        bytesSent: 22020096,
      ),
      ConnectionHistoryEntry(
        id: 'preview-3',
        serverName: 'Tokyo-02',
        country: 'Japan',
        flag: '🇯🇵',
        startedAt: now.subtract(const Duration(days: 1, hours: 2)),
        duration: const Duration(minutes: 45),
        activity: 'Video Call',
        healthScore: 76,
        status: ConnectionHistoryStatus.successful,
        bytesReceived: 92274688,
        bytesSent: 39845888,
      ),
      ConnectionHistoryEntry(
        id: 'preview-4',
        serverName: 'Singapore-02',
        country: 'Singapore',
        flag: '🇸🇬',
        startedAt: now.subtract(const Duration(days: 2, hours: 4)),
        duration: const Duration(minutes: 8),
        activity: 'Streaming',
        healthScore: 58,
        status: ConnectionHistoryStatus.issue,
        bytesReceived: 11534336,
        bytesSent: 3145728,
        note: 'Connection quality dropped before the session ended.',
      ),
      ConnectionHistoryEntry(
        id: 'preview-5',
        serverName: 'US-West-01',
        country: 'United States',
        flag: '🇺🇸',
        startedAt: now.subtract(const Duration(days: 5)),
        duration: const Duration(hours: 2, minutes: 33),
        activity: 'Development',
        healthScore: 91,
        status: ConnectionHistoryStatus.successful,
        bytesReceived: 314572800,
        bytesSent: 70254592,
      ),
    ];
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 19),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF12447F),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF7093B9),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF12447F),
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF7093B9), size: 14),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF7093B9), fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SessionDetailsSheet extends StatelessWidget {
  const _SessionDetailsSheet({
    required this.session,
    required this.deepBlue,
    required this.blue,
    required this.green,
    required this.red,
    required this.line,
    required this.mutedBlue,
    required this.isPreview,
  });

  final ConnectionHistoryEntry session;
  final Color deepBlue;
  final Color blue;
  final Color green;
  final Color red;
  final Color line;
  final Color mutedBlue;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final statusColor = session.status == ConnectionHistoryStatus.successful
        ? green
        : red;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F9FD),
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(session.flag, style: const TextStyle(fontSize: 34)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.serverName,
                          style: TextStyle(
                            color: deepBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          session.country,
                          style: TextStyle(color: mutedBlue, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      session.status == ConnectionHistoryStatus.successful
                          ? 'Successful'
                          : 'Issue',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'SESSION DETAILS',
                style: TextStyle(
                  color: Color(0xFF7093B9),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              _DetailRow(
                label: 'Started',
                value:
                    '${_formatDate(session.startedAt)} · ${_clock(session.startedAt)}',
              ),
              _DetailRow(label: 'Duration', value: _duration(session.duration)),
              _DetailRow(label: 'Activity profile', value: session.activity),
              _DetailRow(
                label: 'Connection health',
                value: '${session.healthScore}/100',
              ),
              _DetailRow(
                label: 'Data received',
                value: _formatBytes(session.bytesReceived),
              ),
              _DetailRow(
                label: 'Data sent',
                value: _formatBytes(session.bytesSent),
              ),
              if (session.note != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF9C8CC)),
                  ),
                  child: Text(
                    session.note!,
                    style: const TextStyle(
                      color: Color(0xFF9C343C),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
              if (isPreview) ...[
                const SizedBox(height: 12),
                Text(
                  'These are preview values, not live telemetry.',
                  style: TextStyle(
                    color: mutedBlue,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: blue,
                    side: BorderSide(color: line),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String _clock(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    return '$hour:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  static String _duration(Duration duration) {
    if (duration.inDays > 0)
      return '${duration.inDays}d ${duration.inHours % 24}h';
    if (duration.inHours > 0)
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    if (duration.inMinutes > 0) return '${duration.inMinutes}m';
    return '${duration.inSeconds}s';
  }

  static String _formatBytes(int bytes) {
    const kb = 1024;
    const mb = kb * 1024;
    const gb = mb * 1024;
    if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(2)} GB';
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(1)} MB';
    if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(1)} KB';
    return '$bytes B';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDCEBFA))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF7093B9), fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF12447F),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
