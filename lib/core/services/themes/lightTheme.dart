// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LightTheme {
  ThemeData customLightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        color: Colors.black87,
        height: 2,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
          fontFamily: 'SourceSansPro',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(
        fontFamily: 'SourceSansPro',
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 30.0,
      ),
      bodyLarge: TextStyle(
          fontFamily: 'SourceSansPro',
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(
        fontFamily: 'SourceSansPro',
        fontSize: 14,
        color: Colors.black45,
      ),
      bodySmall: TextStyle(
        fontFamily: 'SourceSansPro',
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    ),
  );
}
