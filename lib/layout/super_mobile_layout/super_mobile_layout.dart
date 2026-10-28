import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../constants/colors/colors.dart';
import '../../screens/mobile/super_mobile/super_mobile_ai_assistance/super_mobile_ai_assistance.dart';
import '../../screens/mobile/super_mobile/super_mobile_ai_assistance/super_mobile_assistant_fab.dart';

class SuperMobileLayout extends StatefulWidget {
  final StatefulNavigationShell superMobileNavigationShell;

  const SuperMobileLayout({
    super.key,
    required this.superMobileNavigationShell,
  });

  @override
  State<SuperMobileLayout> createState() => _SuperMobileLayoutState();
}

class _SuperMobileLayoutState extends State<SuperMobileLayout> {
  void goToBranch(int index) {
    widget.superMobileNavigationShell.goBranch(
      index,
      initialLocation: index == widget.superMobileNavigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = widget.superMobileNavigationShell.currentIndex;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.superMobileNavigationShell,
          Positioned(
            right: 16,
            bottom: 16,
            child: SuperMobileAssistantFab(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SuperMobileAiAssistance(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: goToBranch,
        indicatorColor: background,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        animationDuration: const Duration(milliseconds: 300),
        height: 70,
        backgroundColor: background,
        // Label colors
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: deepBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return TextStyle(
            color: unselected,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          );
        }),
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_filled, color: deepBlue),
            icon: Icon(Icons.home_outlined, color: unselected),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.hub_rounded, color: deepBlue),
            icon: Icon(Icons.hub_outlined, color: unselected),
            label: 'Servers',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.health_and_safety, color: deepBlue),
            icon: Icon(Icons.health_and_safety_outlined, color: unselected),
            label: 'Diagnostics',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_rounded, color: deepBlue),
            icon: Icon(Icons.person_outline_rounded, color: unselected),
            label: 'Profile',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.menu, color: deepBlue),
            icon: Icon(Ionicons.menuOutline, color: unselected),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
