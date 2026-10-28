import 'package:flutter/material.dart';
import 'logout_elevated_button_text.dart';

class WebElevatedLogoutButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  const WebElevatedLogoutButton({
    super.key,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: color, elevation: 0),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: LogoutElevatedButtonText(),
      ),
    );
  }
}
