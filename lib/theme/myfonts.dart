import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme myfonts = TextTheme(
  headlineLarge: GoogleFonts.nunito(
      fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineMedium: GoogleFonts.nunito(fontSize: 25, fontWeight: FontWeight.w400),
  headlineSmall: GoogleFonts.nunito(
      fontSize: 21, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleLarge: GoogleFonts.nunito(
      fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleMedium: GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  titleSmall: GoogleFonts.nunito(
      fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyLarge: GoogleFonts.nunito(
      fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.25),
  bodyMedium: GoogleFonts.nunito(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 1.25),
  bodySmall: GoogleFonts.nunito(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.nunito(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

TextTheme getText(BuildContext context) => Theme.of(context).textTheme;
ColorScheme getColor(BuildContext context) => Theme.of(context).colorScheme;




// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';


// TextTheme myfonts = TextTheme(

//   headline1: GoogleFonts.nunito(
//       fontSize: 101, fontWeight: FontWeight.w300, letterSpacing: -1.5),
//   headline2: GoogleFonts.nunito(
//       fontSize: 63, fontWeight: FontWeight.w300, letterSpacing: -0.5),
//   headline3: GoogleFonts.nunito(fontSize: 50, fontWeight: FontWeight.w400),
//   headline4: GoogleFonts.nunito(
//       fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0.25),
//   headline5: GoogleFonts.nunito(fontSize: 25, fontWeight: FontWeight.w400),
//   headlineSmall: GoogleFonts.nunito(
//       fontSize: 21, fontWeight: FontWeight.w500, letterSpacing: 0.15),
//   titleLarge: GoogleFonts.nunito(
//       fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.15),
//   titleMedium: GoogleFonts.nunito(
//       fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1,),
//   bodyLarge: GoogleFonts.nunito(
//       fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5),
//   bodyMedium: GoogleFonts.nunito(
//       fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
//   button: GoogleFonts.nunito(
//       fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
//   bodySmall: GoogleFonts.nunito(
//       fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
//   overline: GoogleFonts.nunito(
//       fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),

// );

// TextTheme  getText(BuildContext context) => Theme.of(context).textTheme;
// ColorScheme getColor(BuildContext context)=> Theme.of(context).colorScheme;
