import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class Heading3 extends StatelessWidget {
  final String text;
  const Heading3({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: newBlue,
              fontSize: 14,
              fontWeight: FontWeight.w400
          ),
        )
    );
  }
}