import 'package:flutter/material.dart';

/// Result states for the DēGlitch diagnostic checklist.
enum DiagnosticCheckState {
  pending,
  running,
  passed,
  failed,
  unavailable,
  cancelled,
}

/// Diagnostic checks supported by the screen.
enum DiagnosticCheckType {
  internetConnection,
  dns,
  packetLoss,
  latency,
  jitter,
  serverLoad,
  vpnEndpoint,
}

/// A result returned by a real diagnostic implementation.
class DiagnosticCheckResult {
  const DiagnosticCheckResult({required this.state, this.detail});

  final DiagnosticCheckState state;
  final String? detail;
}

/// A callback may connect the UI to real probes and the WireGuard service.
///
/// The screen uses clearly labelled preview results when [onRunCheck] is not
/// provided. It never presents those preview results as real measurements.
typedef DiagnosticRunner =
    Future<DiagnosticCheckResult> Function(DiagnosticCheckType check);

class SuperMobileDiagnostics extends StatefulWidget {
  const SuperMobileDiagnostics({super.key, this.onRunCheck});

  /// Supply a real runner to replace the built-in demonstration sequence.
  final DiagnosticRunner? onRunCheck;

  @override
  State<SuperMobileDiagnostics> createState() => _SuperMobileDiagnosticsState();
}

class _DiagnosticItem {
  const _DiagnosticItem(this.type, this.title);

  final DiagnosticCheckType type;
  final String title;
}

class _SuperMobileDiagnosticsState extends State<SuperMobileDiagnostics> {
  static const Color _blue = Color(0xFF0878F9);
  static const Color _deepBlue = Color(0xFF12447F);
  static const Color _mutedBlue = Color(0xFF7193B7);
  static const Color _page = Color(0xFFF2F8FD);
  static const Color _line = Color(0xFFDCEBFA);
  static const Color _green = Color(0xFF14A779);
  static const Color _red = Color(0xFFE05A5A);
  static const Color _amber = Color(0xFFF0A52B);

  static const List<_DiagnosticItem> _items = [
    _DiagnosticItem(
      DiagnosticCheckType.internetConnection,
      'Internet Connection',
    ),
    _DiagnosticItem(DiagnosticCheckType.dns, 'DNS'),
    _DiagnosticItem(DiagnosticCheckType.packetLoss, 'Packet Loss Test'),
    _DiagnosticItem(DiagnosticCheckType.latency, 'Latency Test'),
    _DiagnosticItem(DiagnosticCheckType.jitter, 'Jitter Test'),
    _DiagnosticItem(DiagnosticCheckType.serverLoad, 'Server Load'),
    _DiagnosticItem(DiagnosticCheckType.vpnEndpoint, 'VPN Endpoint'),
  ];

  late Map<DiagnosticCheckType, DiagnosticCheckResult> _results;
  bool _isRunning = false;
  bool _cancelRequested = false;
  int _runId = 0;

  int get _completedCount => _results.values
      .where(
        (result) =>
            result.state == DiagnosticCheckState.passed ||
            result.state == DiagnosticCheckState.failed ||
            result.state == DiagnosticCheckState.unavailable,
      )
      .length;

  @override
  void initState() {
    super.initState();
    _resetResults();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _runDiagnostics();
    });
  }

  void _resetResults() {
    _results = {
      for (final item in _items)
        item.type: const DiagnosticCheckResult(
          state: DiagnosticCheckState.pending,
        ),
    };
  }

  Future<void> _runDiagnostics() async {
    if (_isRunning) return;
    final currentRunId = ++_runId;
    setState(() {
      _isRunning = true;
      _cancelRequested = false;
      _resetResults();
    });

    for (var index = 0; index < _items.length; index++) {
      if (!_canContinue(currentRunId)) break;
      final item = _items[index];
      setState(() {
        _results[item.type] = const DiagnosticCheckResult(
          state: DiagnosticCheckState.running,
        );
      });

      try {
        final result = await _runOne(item.type);
        if (!_canContinue(currentRunId)) break;
        setState(() => _results[item.type] = result);
      } catch (error) {
        if (!_canContinue(currentRunId)) break;
        setState(() {
          _results[item.type] = DiagnosticCheckResult(
            state: DiagnosticCheckState.failed,
            detail: 'Check failed: $error',
          );
        });
      }
    }

    if (!mounted || currentRunId != _runId) return;
    setState(() {
      if (_cancelRequested) {
        for (final item in _items) {
          if (_results[item.type]!.state == DiagnosticCheckState.pending ||
              _results[item.type]!.state == DiagnosticCheckState.running) {
            _results[item.type] = const DiagnosticCheckResult(
              state: DiagnosticCheckState.cancelled,
            );
          }
        }
      }
      _isRunning = false;
    });
  }

  bool _canContinue(int runId) =>
      mounted && runId == _runId && !_cancelRequested;

  Future<DiagnosticCheckResult> _runOne(DiagnosticCheckType type) async {
    final runner = widget.onRunCheck;
    if (runner != null) return runner(type);

    // UI preview only. Replace with platform/network probes before treating
    // these states as test evidence.
    await Future<void>.delayed(const Duration(milliseconds: 850));
    switch (type) {
      case DiagnosticCheckType.internetConnection:
      case DiagnosticCheckType.dns:
      case DiagnosticCheckType.packetLoss:
      case DiagnosticCheckType.latency:
      case DiagnosticCheckType.jitter:
        return const DiagnosticCheckResult(
          state: DiagnosticCheckState.passed,
          detail: 'Preview result only',
        );
      case DiagnosticCheckType.serverLoad:
        return const DiagnosticCheckResult(
          state: DiagnosticCheckState.unavailable,
          detail: 'Server telemetry is not connected',
        );
      case DiagnosticCheckType.vpnEndpoint:
        return const DiagnosticCheckResult(
          state: DiagnosticCheckState.unavailable,
          detail: 'Live tunnel status is not connected to diagnostics',
        );
    }
  }

  void _cancel() {
    if (!_isRunning) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _cancelRequested = true);
  }

  String get _headline {
    if (_isRunning) return 'Running Tests...';
    if (_cancelRequested) return 'Tests Cancelled';
    return 'Diagnostics Complete';
  }

  String get _subheadline {
    if (_isRunning) return 'This may take a few seconds';
    if (_cancelRequested) return 'You can run the diagnostics again';
    return '$_completedCount of ${_items.length} checks have results';
  }

  @override
  void dispose() {
    _runId++;
    _cancelRequested = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

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
          'Diagnostics',
          style: TextStyle(
            color: _deepBlue,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  _buildProgressCard(),
                  const SizedBox(height: 14),
                  _buildChecksCard(),
                  const SizedBox(height: 12),
                  _buildEndpointCard(),
                  if (screenHeight < 660) const SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _isRunning
                      ? _cancel
                      : (_cancelRequested || _completedCount > 0
                            ? _runDiagnostics
                            : () => Navigator.of(context).maybePop()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _blue,
                    backgroundColor: Colors.white.withValues(alpha: 0.35),
                    side: const BorderSide(
                      color: Color(0xFFCAE5FF),
                      width: 1.5,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    _isRunning
                        ? 'Cancel'
                        : (_cancelRequested || _completedCount > 0
                              ? 'Run Again'
                              : 'Close'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FF),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFD9EEFF)),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.8),
              border: Border.all(color: const Color(0xFFBFE2FF), width: 1.5),
            ),
            child: Center(
              child: _isRunning
                  ? const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        color: _blue,
                      ),
                    )
                  : Icon(
                      _cancelRequested
                          ? Icons.pause_circle_outline_rounded
                          : Icons.check_circle_outline_rounded,
                      color: _cancelRequested ? _amber : _blue,
                      size: 27,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _headline,
                  style: const TextStyle(
                    color: _deepBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _subheadline,
                  style: const TextStyle(
                    color: _mutedBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: _isRunning ? null : _completedCount / _items.length,
                    backgroundColor: const Color(0xFFD8ECFC),
                    valueColor: const AlwaysStoppedAnimation<Color>(_blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D3A94E8),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < 5; index++) ...[
            _buildCheckRow(_items[index]),
            if (index != 4)
              const Padding(
                padding: EdgeInsets.only(left: 42),
                child: Divider(height: 1, color: Color(0xFFEEF5FC)),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildEndpointCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          _buildCheckRow(_items[5]),
          const Padding(
            padding: EdgeInsets.only(left: 42),
            child: Divider(height: 1, color: Color(0xFFEEF5FC)),
          ),
          _buildCheckRow(_items[6]),
        ],
      ),
    );
  }

  Widget _buildCheckRow(_DiagnosticItem item) {
    final result = _results[item.type]!;
    final state = result.state;
    final statusLabel = switch (state) {
      DiagnosticCheckState.pending => 'Pending',
      DiagnosticCheckState.running => 'Checking…',
      DiagnosticCheckState.passed => 'Passed',
      DiagnosticCheckState.failed => 'Failed',
      DiagnosticCheckState.unavailable => 'Unavailable',
      DiagnosticCheckState.cancelled => 'Cancelled',
    };
    final color = switch (state) {
      DiagnosticCheckState.passed => _green,
      DiagnosticCheckState.failed => _red,
      DiagnosticCheckState.running => _blue,
      DiagnosticCheckState.unavailable => _mutedBlue,
      DiagnosticCheckState.cancelled => _amber,
      DiagnosticCheckState.pending => _mutedBlue,
    };
    final icon = switch (state) {
      DiagnosticCheckState.passed => Icons.check_rounded,
      DiagnosticCheckState.failed => Icons.close_rounded,
      DiagnosticCheckState.running => Icons.sync_rounded,
      DiagnosticCheckState.unavailable => Icons.remove_rounded,
      DiagnosticCheckState.cancelled => Icons.pause_rounded,
      DiagnosticCheckState.pending => Icons.circle_outlined,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state == DiagnosticCheckState.pending
                  ? Colors.transparent
                  : color,
              border: state == DiagnosticCheckState.pending
                  ? Border.all(color: const Color(0xFF80B5EC), width: 1.7)
                  : null,
            ),
            child: Icon(
              icon,
              size: 13,
              color: state == DiagnosticCheckState.pending
                  ? _mutedBlue
                  : Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _deepBlue,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (result.detail != null &&
                    state != DiagnosticCheckState.passed) ...[
                  const SizedBox(height: 3),
                  Text(
                    result.detail!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _mutedBlue, fontSize: 9),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: state == DiagnosticCheckState.pending ? 0 : 0.10,
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: color,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildPreviewNote() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF7E4B5)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFAE7918), size: 17),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Preview mode: results are samples. Connect real network probes and tunnel telemetry before using this screen for actual diagnostics.',
              style: TextStyle(
                color: Color(0xFF896519),
                fontSize: 10,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}
