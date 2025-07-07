import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';

/// 앱 진입점(main) - Supabase 초기화 및 앱 실행
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Supabase 프로젝트 초기화 (DB 연동)
  await Supabase.initialize(
    url: 'https://sihwkdcskqhlovoabsjs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpaHdrZGNza3FobG92b2Fic2pzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE3NjY1MzYsImV4cCI6MjA2NzM0MjUzNn0.hvqsPvGf312PbLvG172j-yIMe02yAQ23GXb_Z6wsvNk',
  );
  runApp(const MyApp());
}

/// 앱 전체를 감싸는 루트 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '맛집지도',
      theme: AppTheme.themeData,
      home: const SplashScreen(), // 앱 시작 시 SplashScreen 표시
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
