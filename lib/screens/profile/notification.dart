import 'package:flutter/material.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atur Notifikasi")),
      body: const Center(
        child: Text(
          "Halaman pengaturan notifikasi",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
