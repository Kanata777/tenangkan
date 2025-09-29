import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/auth/login.dart';
import 'screens/dashboard.dart';
import 'screens/auth/forgot_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tenangkan.id",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LandingPage(),
        '/login': (_) => const LoginPage(),
        '/dashboard': (_) => const DashboardPage(),
        '/forgot': (_) => const ForgotPasswordPage(),
      },
    );
  }
}
