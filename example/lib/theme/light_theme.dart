import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme(ColorScheme? dynamicColorScheme) {
  final colorScheme = dynamicColorScheme ??
      ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: Colors.black,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.dmSansTextTheme().apply(
      bodyColor: colorScheme.onBackground,
    ),
  );
}
