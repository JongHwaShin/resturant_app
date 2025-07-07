import 'dart:async';
import 'package:flutter/material.dart';

/// SplashScreen: 라멘 PNG 이미지만 2초간 표시
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2초 후 자동 이동
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/ramen.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
} 