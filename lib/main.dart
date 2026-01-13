import 'package:flutter/material.dart';
import 'soundboard/soundboard_screen.dart';

void main() {
  runApp(const SoundboardApp());
}

class SoundboardApp extends StatelessWidget {
  const SoundboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soundboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0F1115),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6C5CE7), // violet accent
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F1115),
    elevation: 0,
    centerTitle: true,
  ),
),

      home: const SoundboardScreen(),
    );
  }
}
