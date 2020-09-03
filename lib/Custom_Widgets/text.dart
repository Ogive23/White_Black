import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget text(sentence, color, fontSize, letterSpacing, fontWeight) {
  return Text(
    '$sentence',
    textAlign: TextAlign.center,
    style: GoogleFonts.adventPro(
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        decoration: TextDecoration.none),
  );
}
