// lib/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';

/// Tab yang tersedia di bottom nav
enum AppTab { dashboard, products, events, profile }

class AppBottomNav extends StatelessWidget {
  final AppTab current;
  final ValueChanged<AppTab>? onChanged;

  const AppBottomNav({
    super.key,
    required this.current,
    this.onChanged,
  });

  int get _index {
    switch (current) {
      case AppTab.dashboard:
        return 0;
      case AppTab.products:
        return 1;
      case AppTab.events:
        return 2;
      case AppTab.profile:
        return 3;
    }
  }

  void _handleTap(BuildContext context, int i) {
    // Mapping index -> AppTab (tanpa pattern matching, aman untuk Dart lama)
    AppTab tab = AppTab.dashboard;
    switch (i) {
      case 0:
        tab = AppTab.dashboard;
        break;
      case 1:
        tab = AppTab.products;
        break;
      case 2:
        tab = AppTab.events;
        break;
      case 3:
        tab = AppTab.profile;
        break;
    }

    // Jika caller menyediakan onChanged, serahkan logika navigasinya ke caller
    if (onChanged != null) {
      onChanged!(tab);
      return;
    }

    // Default: navigasi named routes (disesuaikan dengan project-mu)
    switch (tab) {
      case AppTab.dashboard:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case AppTab.products:
        Navigator.pushReplacementNamed(context, '/produk'); // <- rute kamu
        break;
      case AppTab.events:
        Navigator.pushReplacementNamed(context, '/events');
        break;
      case AppTab.profile:
        // Jika route '/profile' belum ada, jangan crash
        try {
          Navigator.pushReplacementNamed(context, '/profile');
        } catch (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Halaman Profil belum tersedia')),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 14,
                offset: Offset(0, 6),
                color: Color(0x19000000),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: NavigationBar(
              height: 64,
              backgroundColor: Colors.white,
              indicatorColor: Colors.teal.withOpacity(.12),
              selectedIndex: _index,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (i) => _handleTap(context, i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: 'Produk',
                ),
                NavigationDestination(
                  icon: Icon(Icons.event_outlined),
                  selectedIcon: Icon(Icons.event),
                  label: 'Event',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
    static AppTab _parseRouteName(String? name) {
    switch (name) {
      case '/dashboard':
      case '/':
        return AppTab.dashboard;
      case '/produk':
        return AppTab.products;
      case '/events':
        return AppTab.events;
      case '/profile':
        return AppTab.profile;
      default:
        return AppTab.dashboard;
    }
  }

  // Builder helper agar bisa akses context dan auto-detect tab
  static Widget auto({Key? key, ValueChanged<AppTab>? onChanged}) {
    return Builder(
      builder: (context) {
        final routeName = ModalRoute.of(context)?.settings.name;
        final current = _parseRouteName(routeName);
        return AppBottomNav(key: key, current: current, onChanged: onChanged);
      },
    );
  }

}
