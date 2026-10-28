import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class LogoutElevatedButtonText extends StatelessWidget {
  const LogoutElevatedButtonText({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      'Ok',
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: background,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
