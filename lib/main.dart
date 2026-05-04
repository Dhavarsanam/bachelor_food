import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/screens/create_account_screen.dart';
import 'features/home/dashboard_screen.dart';

void main() {
  runApp(const BachelorFoodsApp());
}

class BachelorFoodsApp extends StatelessWidget {
  const BachelorFoodsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bachelor Foods',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/dashboard': (_) => const DashboardScreen(),          // ✅ RENAMED from /home
      },
    );
  }
}