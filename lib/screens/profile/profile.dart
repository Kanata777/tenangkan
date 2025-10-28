import 'package:flutter/material.dart';
import 'profile_edit.dart';
import 'notification.dart';
import 'help.dart';
import 'information.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Data profil yang bisa diubah
  String nama = "Kim Jueun";
  String peran = "Ibu Rumah Tangga";
  String usia = "25";
  String hobi = "Membaca";
  String tagline = "Wellness Enthusiast 🌿";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas (Header + Info Cards)
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade400,
                      Colors.green.shade200,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Header dengan foto profil
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
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
                                color: Colors.green.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Informasi pribadi singkat
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
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
                                "$usia",
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
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bagian bawah (Menu)
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _sectionTitle("Setting"),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Edit Profil
                              Expanded(
                                child: _menuTile(
                                  context,
                                  icon: Icons.person,
                                  title: "Edit Profile Saya",
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileDetailPage(
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
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 20,
                                color: Colors.grey.shade200,
                              ),

                              // Notifikasi
                              Expanded(
                                child: _menuTile(
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
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 20,
                                color: Colors.grey.shade200,
                              ),

                              // Informasi Akun
                              Expanded(
                                child: _menuTile(
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
                              ),
                              Divider(
                                height: 1,
                                indent: 60,
                                endIndent: 20,
                                color: Colors.grey.shade200,
                              ),

                              // Bantuan
                              Expanded(
                                child: _menuTile(
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.green.shade700, size: 22),
    ),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 12,
      color: Colors.grey.shade600,
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
