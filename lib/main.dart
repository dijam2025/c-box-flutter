import 'package:c_box/screens/rental_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/category_provider.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_menu_page.dart';
import 'screens/main_screen.dart'; // 하단바 통합 구조
import 'screens/splash.dart'; // 여기선 SplashPage 사용!

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => RentalStatusProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C:Box',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Pretendard',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),

      // ✅ 아래 테마를 추가해주면 하단바 배경색이 모든 페이지에서 흰색으로 통일됨
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,        // 하단바 배경
        selectedItemColor: Colors.indigo,     // 선택된 아이템 색
        unselectedItemColor: Colors.grey,     // 선택 안된 아이템 색
        type: BottomNavigationBarType.fixed,  // 애니메이션 효과 방지
      ),
    ),

      // SplashPage가 앱 시작 화면
      home: SplashPage(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home_menu_page': (context) => const HomeMenuPage(),
        '/main': (context) => const MainScreen(), // 필요 시 MainScreen으로도 이동 가능
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
