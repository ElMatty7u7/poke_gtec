import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    primarySwatch: Colors.red,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    scaffoldBackgroundColor: Colors.grey.shade100,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
  );
}
