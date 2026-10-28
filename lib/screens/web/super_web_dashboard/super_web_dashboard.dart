import 'package:flutter/material.dart';
import '../../../widgets/web_dashboard_shimmer.dart';

class SuperWebDashboard extends StatefulWidget {
  const SuperWebDashboard({super.key});

  @override
  State<SuperWebDashboard> createState() => _SuperWebDashboardState();
}

class _SuperWebDashboardState extends State<SuperWebDashboard> {
  @override
  Widget build(BuildContext context) {
    return const WebDashboardShimmer();
  }
}
