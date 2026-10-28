import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DēGlitch VPN',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4FAFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0878F9),
          brightness: Brightness.light,
        ),
      ),
      home: const VpnHomeScreen(),
    );
  }
}

const Color navy = Color(0xFF073B7A);
const Color deepBlue = Color(0xFF06468E);
const Color primaryBlue = Color(0xFF0878F9);
const Color paleBlue = Color(0xFFEAF6FF);
const Color textBlue = Color(0xFF163E70);
const Color mutedBlue = Color(0xFF85A8CD);
const Color green = Color(0xFF13B889);

class VpnHomeScreen extends StatefulWidget {
  const VpnHomeScreen({super.key});

  @override
  State<VpnHomeScreen> createState() => _VpnHomeScreenState();
}

class _VpnHomeScreenState extends State<VpnHomeScreen> {
  bool isConnected = true;
  int selectedTab = 0;

  void toggleConnection() {
    setState(() {
      isConnected = !isConnected;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isConnected
              ? 'Connection enabled (demo)'
              : 'Connection disabled (demo)',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE7F5FF), Color(0xFFFFFFFF), Color(0xFFF0F8FF)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    children: [
                      _buildConnectionCard(),
                      const SizedBox(height: 17),
                      _buildQuickAccessTitle(),
                      const SizedBox(height: 9),
                      _buildQuickAccess(),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      /*bottomNavigationBar: _buildBottomNavigation(),*/
    );
  }

  // Header
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 38),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF064184), Color(0xFF00346F)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBCE5FF), width: 2),
            ),
            child: const CircleAvatar(
              backgroundColor: Color(0xFFDCEEFF),
              child: Icon(Icons.person, color: navy, size: 29),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Elijah Fullah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD36A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✦ Premium',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF714B00),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 19,
              onPressed: () => _showMessage('Account settings'),
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Main VPN connection card
  Widget _buildConnectionCard() {
    return Transform.translate(
      offset: const Offset(0, -23),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: const Color(0xFFE1F1FF)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A94E8).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 166,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow rings
                  Container(
                    height: 128,
                    width: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD8F1FF),
                        width: 3,
                      ),
                    ),
                  ),
                  Container(
                    height: 108,
                    width: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB9E8FF),
                        width: 4,
                      ),
                    ),
                  ),
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF149AFF), Color(0xFF005CE5)],
                      ),
                      border: Border.all(
                        color: const Color(0xFF6AD4FF),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: toggleConnection,
                        child: Icon(
                          isConnected
                              ? Icons.power_settings_new
                              : Icons.power_settings_new,
                          color: Colors.white,
                          size: 37,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 18,
                    child: Material(
                      color: const Color(0xFFF7FBFF),
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () => _showMessage('Choose your VPN server'),
                        icon: const Icon(
                          Icons.chevron_right,
                          color: primaryBlue,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Connection status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isConnected ? Icons.check_circle : Icons.cancel,
                  color: isConnected ? green : Colors.redAccent,
                  size: 19,
                ),
                const SizedBox(width: 6),
                Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: isConnected ? textBlue : Colors.redAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),

            InkWell(
              onTap: () => _showMessage('Server selection'),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🇸🇬', style: TextStyle(fontSize: 17)),
                  const SizedBox(width: 6),
                  Text(
                    isConnected ? 'Singapore-03' : 'No server selected',
                    style: const TextStyle(
                      color: Color(0xFF24548C),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Connection statistics
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFBFDFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2F2FF)),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: StatItem(value: '42 ms', label: 'Latency'),
                  ),
                  StatDivider(),
                  Expanded(
                    child: StatItem(value: '0.3%', label: 'Packet Loss'),
                  ),
                  StatDivider(),
                  Expanded(
                    child: StatItem(value: '91', label: 'Health Score'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 12),
        child: Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: textBlue,
          ),
        ),
      ),
    );
  }

  // Quick access cards
  Widget _buildQuickAccess() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0F0FF)),
      ),
      child: Column(
        children: [
          QuickAccessTile(
            icon: Icons.alt_route_rounded,
            title: 'Server Recommendation',
            subtitle: 'AI selects the best server for you',
            onTap: () => _showMessage('Server Recommendation'),
          ),
          _tileDivider(),
          QuickAccessTile(
            icon: Icons.radio_button_checked,
            title: 'Run Diagnostics',
            subtitle: 'Check your connection health',
            onTap: () => _showMessage('Running diagnostics...'),
          ),
          _tileDivider(),
          QuickAccessTile(
            icon: Icons.history_rounded,
            title: 'View Connection History',
            subtitle: 'See past connections',
            onTap: () => _showMessage('Connection History'),
          ),
        ],
      ),
    );
  }

  Widget _tileDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Divider(height: 1, color: const Color(0xFFEAF3FC)),
    );
  }

  // Bottom navigation
  Widget _buildBottomNavigation() {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.hub_rounded, 'Servers'),
      (Icons.health_and_safety_outlined, 'Diagnostics'),
      (Icons.person_outline_rounded, 'Profile'),
      (Icons.menu_rounded, 'More'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE5F1FC))),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 5),
          child: Row(
            children: List.generate(items.length, (index) {
              final isSelected = selectedTab == index;
              final item = items[index];

              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() => selectedTab = index);

                    if (index != 0) {
                      _showMessage('${item.$2} screen');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.$1,
                          size: 20,
                          color: isSelected
                              ? primaryBlue
                              : const Color(0xFF7096BD),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isSelected
                                ? primaryBlue
                                : const Color(0xFF7096BD),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Reusable statistics widget
class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textBlue,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: mutedBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatDivider extends StatelessWidget {
  const StatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 40, width: 1, color: const Color(0xFFD9ECFC));
  }
}

// Reusable quick access tile
class QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickAccessTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE6F5FF), Color(0xFFD3EDFF)],
                  ),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: const Color(0xFFD4EBFF)),
                ),
                child: Icon(icon, color: primaryBlue, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: mutedBlue,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF477DB4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
