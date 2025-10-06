import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/dashboard.dart';
import 'screens/products/product_list.dart';
import 'screens/profile/profile.dart';
import 'screens/events/event_list.dart';
import 'screens/psikolog_list_page.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgot = '/forgot';
  static const String dashboard = '/dashboard';
  static const String product = '/product';
  static const String profile = '/profile';
  static const String event = '/event';
  static const String psikolog = '/psikolog';

  static Map<String, WidgetBuilder> routes = {
    landing: (_) => const LandingPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    forgot: (_) => const ForgotPasswordPage(),
    dashboard: (_) => const DashboardPage(),
    product: (_) => const ProductsListPage(),
    profile: (_) => const ProfilePage(),
    event: (_) => const EventListPage(),
    psikolog: (_) => const PsikologListPage(),
  };
}
