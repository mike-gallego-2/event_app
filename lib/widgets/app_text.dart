import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_app/constants/constants.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color color;
  final double padding;
  final TextAlign? textAlign;
  final double? height;
  const AppText({
    Key? key,
    required this.text,
    this.fontSize = bodyText,
    this.fontWeight,
    this.color = textColor,
    this.padding = 0.0,
    this.textAlign,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: textSpacing,
          height: height,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
