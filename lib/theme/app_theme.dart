import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF5B6EFF);
  static const secondary = Color(0xFF6A7BFF);
  static const background = Color(0xFFF5F6FA);

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: background,
    fontFamily: 'Poppins',
  );

  static LinearGradient mainGradient = const LinearGradient(
    colors: [Color(0xFF6A7BFF), Color(0xFF4A5CFF)],
  );
}
