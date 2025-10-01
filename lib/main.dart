import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // ✅ sudah ditambahkan
import 'screens/landing_page.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/dashboard.dart';
import 'screens/products/product_list.dart';

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

      // 👇 tambahkan di sini
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch, // untuk swipe di layar sentuh (mobile)
          PointerDeviceKind.mouse, // untuk drag di browser/web dan desktop
        },
      ),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.teal.withOpacity(0.12),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.teal); // aktif hijau
            }
            return const IconThemeData(color: Colors.grey); // default abu2
          }),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (_) => const LandingPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/forgot': (_) => const ForgotPasswordPage(),
        '/dashboard': (_) => const DashboardPage(),
        '/produk': (_) => const ProductsListPage(),
      },
    );
  }
}
