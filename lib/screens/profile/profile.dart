import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profil Saya"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan foto profil
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://via.placeholder.com/150", // ganti nanti dengan gambar user
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Nama Pengguna",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const Text(
                    "user@email.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu Profil
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: const Text("Edit Profil"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: navigasi ke halaman edit profil
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.teal),
              title: const Text("Alamat Saya"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: navigasi ke halaman alamat
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.history, color: Colors.teal),
              title: const Text("Riwayat Transaksi"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: navigasi ke halaman riwayat
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.teal),
              title: const Text("Pengaturan"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: navigasi ke halaman pengaturan
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                // TODO: tambahkan fungsi logout
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
