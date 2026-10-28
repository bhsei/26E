import 'package:de_glitch/constants/colors/colors.dart';
import 'package:de_glitch/widgets/mobile_header_name.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SuperMobileHome extends StatefulWidget {
  const SuperMobileHome({super.key});

  @override
  State<SuperMobileHome> createState() => _SuperMobileHomeState();
}

class _SuperMobileHomeState extends State<SuperMobileHome> {
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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF064184), Color(0xFF00346F)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Color(0xFF064184),
                  surfaceTintColor: Colors.transparent,
                  title: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: background, width: 2),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/pro.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MobileHeaderText(text: 'Elijah Fullah'),
                            const Gap(5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: premium,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: primary,
                                    size: 16,
                                  ),
                                  const Gap(5),
                                  Text(
                                    'Premium',
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: premium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(10),

                    // Connection card, Quick Access and statistics
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.9,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Connection card
                          Positioned(
                            top: 0,
                            left: 15,
                            right: 15,
                            child: _buildConnectionCard(),
                          ),

                          // Quick Access panel
                          Positioned(
                            top: 280,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                15,
                                65,
                                15,
                                20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.96),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Gap(10),
                                  _buildQuickAccessTitle(),
                                  const Gap(20),
                                  _buildQuickAccess(),
                                ],
                              ),
                            ),
                          ),

                          // Statistics card above both panels
                          Positioned(
                            top: 265,
                            left: 30,
                            right: 30,
                            child: Material(
                              elevation: 3,
                              color: const Color(0xFFFBFDFF),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFE2F2FF),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      child: StatItem(
                                        value: '42 ms',
                                        label: 'Latency',
                                      ),
                                    ),
                                    StatDivider(),
                                    Expanded(
                                      child: StatItem(
                                        value: '0.3%',
                                        label: 'Packet Loss',
                                      ),
                                    ),
                                    StatDivider(),
                                    Expanded(
                                      child: StatItem(
                                        value: '91',
                                        label: 'Health Score',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Main VPN connection card
  Widget _buildConnectionCard() {
    return Transform.translate(
      offset: const Offset(0, 0),
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
              height: 190,
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
            const Gap(7),

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
            const Gap(20),
          ],
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
