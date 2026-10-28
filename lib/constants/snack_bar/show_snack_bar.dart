import 'package:flutter/material.dart';
import '../../widgets/heading3.dart';
import '../colors/colors.dart';

class ShowSnackBar extends StatelessWidget {
  final String text;
  final String label;
  final Function() action;
  const ShowSnackBar({
    super.key,
    required this.text,
    required this.label,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: SnackBar(
        content: Heading3(text: text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(label: label, onPressed: action),
      ),
    );
  }
}
