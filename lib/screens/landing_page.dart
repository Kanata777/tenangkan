import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topTeal = Color(0xFF6AAFA8);
    const Color bottomTeal = Color.fromARGB(255, 0, 159, 138);

    final items = const [
      _IntroItem(
        title: 'E-Book Stres Release',
        subtitle: 'Untuk Ibu Rumah\nTangga.',
        icon: Icons.menu_book_rounded,
      ),
      _IntroItem(
        title: 'E-Book Stres Release',
        subtitle: 'Untuk Ibu &\nWanita Karier.',
        icon: Icons.menu_book_rounded,
      ),
      _IntroItem(
        title: 'E-Book Stres Release',
        subtitle: 'Untuk Ibu dengan Anak\nBerkebutuhan Khusus.',
        icon: Icons.menu_book_rounded,
      ),
      _IntroItem(
        title: 'Mindfulness',
        subtitle: 'Latihan kesadaran diri\n& relaksasi ringan.',
        icon: Icons.self_improvement,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [topTeal, bottomTeal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 0), // 🔹 judul agak turun
                  child: Column(
                    children: [
                      const Text(
                        'Tenangkan.id',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Program Stress Release untuk menemukan kembali ketenangan, fokus, dan keseimbangan diri.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.5,
                          height: 1.4,
                        ),
                      ),

                      // 🔽 tambahkan jarak supaya bagian grid turun lebih jauh
                      const SizedBox(height: 56),

                      // 🔹 Grid dua kolom
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.42,
                        children: [
                          for (final item in items) _SmallFeatureCard(item: item),
                        ],
                      ),

                      const SizedBox(height: 8), // jarak kecil ke tombol
                    ],
                  ),
                ),
              ),

              // 🔹 Tombol di tengah bawah
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: bottomTeal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Mulai Jelajah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroItem {
  final String title;
  final String subtitle;
  final IconData icon;
  const _IntroItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _SmallFeatureCard extends StatelessWidget {
  final _IntroItem item;
  const _SmallFeatureCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120, maxHeight: 158),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: Colors.white, size: 27),
          const SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
