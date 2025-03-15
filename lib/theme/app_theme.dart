import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green,
      elevation: 4,
      centerTitle: true,
    ),
  );
}