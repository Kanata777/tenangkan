import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../routes.dart';
import 'profile_edit.dart';
import 'notification.dart';
import 'help.dart';
import 'information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const Color topTeal = Color(0xFF6AAFA8);
const Color bottomTeal = Color(0xFF009F8A);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Data profil yang bisa diubah
  String nama = "";
  String peran = "";
  String usia = "";
  String hobi = "";
  String tagline = "Wellness Enthusiast 🌿";

String? photoUrl;
bool _uploadingPhoto = false;

 @override
void initState() {
  super.initState();

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      _loadUserProfile();
    } else {
      setState(() {
        nama = "Pengguna";
        peran = "";
        usia = "";
        hobi = "";
        photoUrl = null;
      });
    }
  });
}

  

Future<void> _loadUserProfile() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  if (!doc.exists) return;

  final data = doc.data()!;

  if (!mounted) return;

  setState(() {
    nama = user.displayName ?? data['nama'] ?? "Pengguna";
    peran = data['peran'] ?? '';
    usia = data['usia']?.toString() ?? '';
    hobi = data['hobi'] ?? '';
    photoUrl = data['photoUrl'];
  });
}




  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // Tidak wajib setState karena StreamBuilder akan rebuild sendiri,
    // tapi kalau mau boleh dibiarkan.
      setState(() {
    nama = "Pengguna";
    peran = "";
    usia = "";
    hobi = "";
    photoUrl = null;
  });
  }

  /// Sensor email: tampilkan beberapa huruf depan + '@gmail.com'
  String _maskedEmail(String? email) {
    if (email == null || !email.contains('@')) return 'Pengguna';

    final parts = email.split('@');
    final local = parts[0];

    // tampilkan 3 huruf pertama saja, sisanya bintang
    final visibleLen = local.length <= 3 ? local.length : 3;
    final visible = local.substring(0, visibleLen);

    return '$visible***@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 BAGIAN ATAS – HEADER + INFO KARTU
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                        topTeal,
                        bottomTeal,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Foto profil + nama + tagline
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: bottomTeal.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage("assets/profile.jpg"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tagline,
                        style: TextStyle(
                          color: bottomTeal,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Kartu info singkat
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _profileInfoCard(
                            Icons.woman_rounded,
                            "Peran",
                            peran,
                            Colors.pinkAccent.shade100,
                            Colors.pinkAccent.shade400,
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey.shade200,
                          ),
                          _profileInfoCard(
                            Icons.cake_rounded,
                            "Usia",
                            usia,
                            Colors.orangeAccent.shade100,
                            Colors.orangeAccent.shade400,
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey.shade200,
                          ),
                          _profileInfoCard(
                            Icons.menu_book_rounded,
                            "Hobi",
                            hobi,
                            Colors.lightGreen.shade100,
                            Colors.lightGreen.shade700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 BAGIAN BAWAH – SETTING + LOGIN / LOGOUT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Setting"),
                    const SizedBox(height: 8),

                    // Card menu setting - besar & rapi
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _menuTile(
                            context,
                            icon: Icons.person,
                            title: "Edit Profile Saya",
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileDetailPage(
                                    nama: nama,
                                    usia: usia,
                                    hobi: hobi,
                                    peran: peran,
                                  ),
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  nama = result['nama'];
                                  usia = result['usia'];
                                  hobi = result['hobi'];
                                  peran = result['peran'];
                                  tagline = result['tagline'];
                                });
                              }
                            },
                          ),
                          const Divider(indent: 72, endIndent: 20),

                          _menuTile(
                            context,
                            icon: Icons.settings,
                            title: "Atur Notifikasi",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationSettingPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(indent: 72, endIndent: 20),

                          _menuTile(
                            context,
                            icon: Icons.collections_bookmark,
                            title: "Informasi Akun",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountInfoPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(indent: 72, endIndent: 20),

                          _menuTile(
                            context,
                            icon: Icons.help_outline,
                            title: "Bantuan",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Login / Logout (reactive)
                    StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                          
                        // Belum login → 1 tombol Masuk
                        if (user == null) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text(
                                "Masuk / Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                backgroundColor: bottomTeal,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                            ),
                          );
                        }

                        // Sudah login → info email + tombol Keluar
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Sedang masuk sebagai",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _maskedEmail(user.email),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.logout),
                                label: const Text(
                                  "Keluar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _logout,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 Widget Reusable
Widget _sectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade800,
      letterSpacing: 0.5,
    ),
  );
}

Widget _menuTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    minVerticalPadding: 18,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    leading: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: topTeal.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: bottomTeal, size: 26),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: Colors.grey.shade500,
    ),
    onTap: onTap,
  );
}

Widget _profileInfoCard(
  IconData icon,
  String label,
  String value,
  Color bgColor,
  Color iconColor,
) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [bgColor, bgColor.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

