import 'package:flutter/material.dart';
import 'routes.dart';

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
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.teal.withOpacity(0.12),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.teal); // hijau saat aktif
            }
            return const IconThemeData(color: Colors.grey); // default abu2
          }),
        ),
      ),
      initialRoute: AppRoutes.landing, // ✅ pakai konstanta dari routes.dart
      routes: AppRoutes.routes,        // ✅ panggil peta route dari file terpisah
    );
  }
}
