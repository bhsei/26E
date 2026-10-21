import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';
import '../../constants/colors/colors.dart';
import '../../screens/web/super_web_dashboard/super_web_dashboard.dart';
import '../../widgets/heading3.dart';
import '../../widgets/web_elevated_logout_button.dart';

class SuperWebLayout extends StatefulWidget {
  const SuperWebLayout({super.key});

  @override
  _SuperWebLayoutState createState() => _SuperWebLayoutState();
}
class _SuperWebLayoutState extends State<SuperWebLayout> {
  bool isExpanded = true;
  int selectedIndex = 0;
  int? hoveredIndex;
  bool isConnected = false;
  StreamSubscription? _internetConnectionStreamSubscription;
  final List<Widget> pages = const [
    SuperWebDashboard(),
    SuperWebDashboard(),
    SuperWebDashboard(),
    SuperWebDashboard(),
    SuperWebDashboard(),
  ];
  void showDialogMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Animate(
          effects: [
            FadeEffect(duration: NumDurationExtensions(900).milliseconds, curve: Curves.easeInOut),
          ],
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Heading3(text: 'Logout Alert').animate()
                          .fadeIn(duration: NumDurationExtensions(600).milliseconds)
                          .slide(),
                      const Gap(10),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.005,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: newBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ).animate()
                          .fadeIn(duration: NumDurationExtensions(800).milliseconds)
                          .slide(),
                    ],
                  ),
                  Text('Sign in required after signing out.',
                      style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: newBlue,
                        fontSize: 16
                    ),)).animate()
                      .fadeIn(duration: NumDurationExtensions(1000).milliseconds)
                      .slide(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: newBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      WebElevatedLogoutButton(
                          onTap: (){},
                          color: red
                      )
                    ],
                  ).animate()
                      .fadeIn(duration: NumDurationExtensions(1200).milliseconds)
                      .slide(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildListTile(int index, IconData icon, String text) {
    final isSelected = selectedIndex == index;
    final isHovered = hoveredIndex == index;
    final isActive = isSelected || isHovered;
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredIndex = null;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (text.isNotEmpty) const Gap(10),
                  Icon(
                    icon,
                    size: 20,
                    color: isActive ? newBlue : primary,
                  ),
                  if (text.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: isActive ? newBlue : primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildListTileLogout(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: InkWell(
          onTap: () {
            showDialogMessage(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (text.isNotEmpty) const Gap(10),
                  Icon(
                    icon,
                    size: 20,
                    color: red,
                  ),
                  if (text.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ]
                ]
            ),
          )
      ),
    );
  }
  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.space_dashboard;
      case 1:
        return Icons.local_gas_station;
      case 2:
        return Icons.request_page;
      case 3:
        return IconlyBold.user_2;
      case 4:
        return Ionicons.car;
      default:
        return Icons.error;
    }
  }
  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Fuel';
      case 2:
        return 'Request';
      case 3:
        return 'User';
      case 4:
        return 'Vehicle';
      default:
        return 'Unknown';
    }
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}