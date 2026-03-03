import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    primarySwatch: Colors.red,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.red),
  );
}
