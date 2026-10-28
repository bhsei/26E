import 'package:flutter/material.dart';

/// Server selection and recommendation UI for DēGlitch.
///
/// IMPORTANT: The catalogue and metrics below are demonstration data based on
/// the supplied visual reference. They are not live server telemetry. Pass an
/// [onConnect] callback from the app shell when server-specific tunnel
/// configurations are available. Do not mark a server connected just because
/// it has been selected here.
class SuperMobileServers extends StatefulWidget {
  const SuperMobileServers({
    super.key,
    this.onConnect,
    this.initialServerId = 'sg-03',
    this.connectedServerId,
  });

  /// Called when the user presses Connect. The parent should connect using a
  /// configuration that actually matches [server].
  final Future<void> Function(DeGlitchServer server)? onConnect;

  final String initialServerId;
  final String? connectedServerId;

  @override
  State<SuperMobileServers> createState() => _SuperMobileServersState();
}

class DeGlitchServer {
  const DeGlitchServer({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.latencyMs,
    required this.packetLossPercent,
    required this.healthScore,
    this.recommended = false,
  });

  final String id;
  final String name;
  final String country;
  final String flag;
  final int latencyMs;
  final double packetLossPercent;
  final int healthScore;
  final bool recommended;
}

class _SuperMobileServersState extends State<SuperMobileServers> {
  static const Color _blue = Color(0xFF0878F9);
  static const Color _deepBlue = Color(0xFF12447F);
  static const Color _mutedBlue = Color(0xFF7093B9);
  static const Color _page = Color(0xFFF4F8FC);
  static const Color _line = Color(0xFFDCEBFA);
  static const Color _green = Color(0xFF10B981);

  static const List<DeGlitchServer> _servers = [
    DeGlitchServer(
      id: 'sg-03',
      name: 'Singapore-03',
      country: 'Singapore',
      flag: '🇸🇬',
      latencyMs: 42,
      packetLossPercent: 0.3,
      healthScore: 91,
      recommended: true,
    ),
    DeGlitchServer(
      id: 'hk-01',
      name: 'Hong Kong-01',
      country: 'Hong Kong',
      flag: '🇭🇰',
      latencyMs: 45,
      packetLossPercent: 0.5,
      healthScore: 86,
    ),
    DeGlitchServer(
      id: 'jp-02',
      name: 'Tokyo-02',
      country: 'Japan',
      flag: '🇯🇵',
      latencyMs: 72,
      packetLossPercent: 0.8,
      healthScore: 78,
    ),
    DeGlitchServer(
      id: 'sg-02',
      name: 'Singapore-02',
      country: 'Singapore',
      flag: '🇸🇬',
      latencyMs: 56,
      packetLossPercent: 0.6,
      healthScore: 76,
    ),
    DeGlitchServer(
      id: 'us-west-01',
      name: 'US-West-01',
      country: 'United States',
      flag: '🇺🇸',
      latencyMs: 130,
      packetLossPercent: 1.4,
      healthScore: 63,
    ),
  ];

  late String _selectedId;
  final Set<String> _favorites = {'jp-02'};
  int _filterIndex = 0;
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    _selectedId = _servers.any((s) => s.id == widget.initialServerId)
        ? widget.initialServerId
        : _servers.first.id;
  }

  DeGlitchServer get _selected =>
      _servers.firstWhere((server) => server.id == _selectedId);

  List<DeGlitchServer> get _visibleServers {
    if (_filterIndex == 2) {
      return _servers
          .where((server) => _favorites.contains(server.id))
          .toList();
    }
    if (_filterIndex == 1) return _servers;
    return _servers.where((server) => !server.recommended).toList();
  }

  Future<void> _connectSelected() async {
    if (_connecting) return;

    // No callback means this screen is not wired to the tunnel service yet.
    // Be transparent instead of showing a fake Connected state.
    final connect = widget.onConnect;
    if (connect == null) {
      _showMessage(
        'Server catalogue preview only. Import a matching WireGuard profile '
        'and connect it through the tunnel service before using this server.',
      );
      return;
    }

    setState(() => _connecting = true);
    try {
      await connect(_selected);
      if (mounted) {
        _showMessage(
          'Connection requested for ${_selected.name}. Verify the real tunnel status.',
        );
      }
    } catch (error) {
      if (mounted) {
        final message = error.toString();
        _showMessage(
          message.length > 140 ? '${message.substring(0, 137)}...' : message,
        );
      }
    } finally {
      if (mounted) setState(() => _connecting = false);
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

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    final connected = widget.connectedServerId == selected.id;

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
          'Server Recommendation',
          style: TextStyle(
            color: _deepBlue,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                children: [
                  _buildFilterTabs(),
                  const SizedBox(height: 18),
                  if (_filterIndex == 0) ...[
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome, color: _green, size: 15),
                        SizedBox(width: 6),
                        Text(
                          'Recommended',
                          style: TextStyle(
                            color: _deepBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildRecommendedCard(_servers.first),
                    const SizedBox(height: 22),
                    const Text(
                      'Other Available Servers',
                      style: TextStyle(
                        color: _deepBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else if (_filterIndex == 1) ...[
                    const Text(
                      'All Available Servers',
                      style: TextStyle(
                        color: _deepBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    const Text(
                      'Your Favorites',
                      style: TextStyle(
                        color: _deepBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_visibleServers.isEmpty) _buildEmptyFavorites(),
                  ],
                  _buildServerList(_visibleServers),
                ],
              ),
            ),
            _buildConnectButton(selected, connected),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    const labels = ['AI Recommended', 'All', 'Favorites'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FD),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = _filterIndex == index;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Material(
                color: selected ? _blue : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _filterIndex = index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 3,
                    ),
                    child: Center(
                      child: Text(
                        labels[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selected ? Colors.white : _mutedBlue,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecommendedCard(DeGlitchServer server) {
    final selected = server.id == _selectedId;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: selected ? const Color(0xFF9AEAE0) : _line,
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => setState(() => _selectedId = server.id),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            children: [
              Row(
                children: [
                  _flagBadge(server.flag, recommended: true),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          server.name,
                          style: const TextStyle(
                            color: _deepBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Lowest measured latency',
                          style: TextStyle(color: _mutedBlue, fontSize: 9.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Best Choice',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _metric('${server.latencyMs} ms', 'Latency')),
                  _verticalDivider(),
                  Expanded(
                    child: _metric(
                      '${server.packetLossPercent.toStringAsFixed(1)}%',
                      'Packet Loss',
                    ),
                  ),
                  _verticalDivider(),
                  Expanded(
                    child: _metric('${server.healthScore}', 'Health Score'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServerList(List<DeGlitchServer> servers) {
    if (servers.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < servers.length; i++) ...[
            _buildServerTile(servers[i]),
            if (i != servers.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 58, right: 12),
                child: Divider(height: 1, color: Color(0xFFEAF2FA)),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildServerTile(DeGlitchServer server) {
    final selected = server.id == _selectedId;
    final favorite = _favorites.contains(server.id);
    return Material(
      color: selected ? const Color(0xFFF0F8FF) : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _selectedId = server.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 9, 10),
          child: Row(
            children: [
              _flagBadge(server.flag),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _deepBlue,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${server.latencyMs} ms  ·  ${server.packetLossPercent.toStringAsFixed(1)}% loss',
                      style: const TextStyle(color: _mutedBlue, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: favorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                onPressed: () {
                  setState(() {
                    if (favorite) {
                      _favorites.remove(server.id);
                    } else {
                      _favorites.add(server.id);
                    }
                  });
                },
                icon: Icon(
                  favorite ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 20,
                  color: favorite ? const Color(0xFFF2B544) : _mutedBlue,
                ),
              ),
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: selected ? _blue : const Color(0xFFE2F3FF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${server.healthScore}',
                  style: TextStyle(
                    color: selected ? Colors.white : _blue,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          Icon(Icons.star_border_rounded, size: 30, color: _mutedBlue),
          SizedBox(height: 8),
          Text(
            'No favorites yet',
            style: TextStyle(color: _deepBlue, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4),
          Text(
            'Tap the star beside a server to save it here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _mutedBlue, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton(DeGlitchServer selected, bool connected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        color: _page,
        border: Border(top: BorderSide(color: Color(0xFFE6EFF8))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _connecting ? null : _connectSelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: connected ? _green : _blue,
              disabledBackgroundColor: _blue.withValues(alpha: 0.6),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: _connecting
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    connected ? 'Connected' : 'Connect to ${selected.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _flagBadge(String flag, {bool recommended = false}) {
    return Container(
      width: recommended ? 34 : 30,
      height: recommended ? 34 : 30,
      decoration: BoxDecoration(
        color: recommended ? const Color(0xFFE9F8F5) : const Color(0xFFF1F7FC),
        shape: BoxShape.circle,
        border: Border.all(color: _line),
      ),
      alignment: Alignment.center,
      child: Text(flag, style: TextStyle(fontSize: recommended ? 19 : 17)),
    );
  }

  Widget _metric(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _deepBlue,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _mutedBlue, fontSize: 9),
        ),
      ],
    );
  }

  Widget _verticalDivider() => Container(
    height: 35,
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    color: _line,
  );
}
