import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget webScaffold;
  const ResponsiveLayout({
    super.key,
    required this.mobileScaffold,
    required this.tabletScaffold,
    required this.webScaffold,
  });
  @override
  _ResponsiveLayoutState createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (screenWidth < 500) {
          return widget.mobileScaffold;
        } else if (screenWidth < 1100) {
          return widget.tabletScaffold;
        } else {
          return widget.webScaffold;
        }
      },
    );
  }
}
