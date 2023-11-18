import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade200,
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade400,
      tertiary: Colors.grey.shade300,
      shadow: Colors.grey.shade100,
      primaryContainer: Colors.white.withAlpha(210),
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade500,
      secondary: Colors.grey.shade700,
      tertiary: const Color.fromARGB(255, 26, 26, 26),
      shadow: Colors.black,
      primaryContainer: Colors.white.withAlpha(10),
    ));
