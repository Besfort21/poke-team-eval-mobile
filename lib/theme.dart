import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background   = Color(0xFF0A0A0A);
  static const surface      = Color(0xFF141414);
  static const surface2     = Color(0xFF1A1A1A);
  static const border       = Color(0xFF2A2A2A);
  static const primary      = Color(0xFFCC0000);
  static const primaryBright= Color(0xFFFF1A1A);
  static const primaryDim   = Color(0xFF660000);
  static const text         = Color(0xFFE8E8E8);
  static const textDim      = Color(0xFF888888);
  static const textMuted    = Color(0xFF444444);
  static const warning      = Color(0xFFCC6600);
  static const warningText  = Color(0xFFFFAA44);
  static const green        = Color(0xFF00CC44);
  static const yellow       = Color(0xFFFFCC00);

  static const typeColors = {
    'normal':   Color(0xFF9A9A78),
    'fire':     Color(0xFFF08030),
    'water':    Color(0xFF6890F0),
    'electric': Color(0xFFF8D030),
    'grass':    Color(0xFF78C850),
    'ice':      Color(0xFF98D8D8),
    'fighting': Color(0xFFC03028),
    'poison':   Color(0xFFA040A0),
    'ground':   Color(0xFFE0C068),
    'flying':   Color(0xFFA890F0),
    'psychic':  Color(0xFFF85888),
    'bug':      Color(0xFFA8B820),
    'rock':     Color(0xFFB8A038),
    'ghost':    Color(0xFF705898),
    'dragon':   Color(0xFF7038F8),
    'dark':     Color(0xFF705848),
    'steel':    Color(0xFFB8B8D0),
    'fairy':    Color(0xFFF0B6BC),
  };

  static Color forType(String type) =>
      typeColors[type.toLowerCase()] ?? const Color(0xFF888888);
}

class AppTextStyles {
  static TextStyle pixel(double size, {Color color = AppColors.text}) =>
      GoogleFonts.pressStart2p(fontSize: size, color: color);

  static TextStyle mono(double size, {Color color = AppColors.text}) =>
      GoogleFonts.shareTechMono(fontSize: size, color: color);
}

ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      surface:   AppColors.surface,
      primary:   AppColors.primary,
      onPrimary: Colors.white,
    ),
    textTheme: GoogleFonts.shareTechMonoTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: AppColors.text, displayColor: AppColors.text),
    dividerColor: AppColors.border,
  );
}