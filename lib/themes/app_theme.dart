import 'package:flutter/material.dart';

/// 앱 전체 테마 정의
class AppTheme {
  static ThemeData get themeData => ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: Colors.yellow[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.primary,
        ),
      );
} 