import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqList = [
      {
        "question": "Bagaimana cara mengubah foto profil?",
        "answer":
            "Kamu bisa mengubah foto profil melalui menu 'Edit Profile Saya' di halaman Pengaturan."
      },
      {
        "question": "Bagaimana cara melihat riwayat transaksi?",
        "answer":
            "Buka menu 'Transaksi Saya' di dashboard utama, lalu pilih transaksi yang ingin kamu lihat."
      },
      {
        "question": "Mengapa notifikasi tidak muncul?",
        "answer":
            "Pastikan izin notifikasi untuk aplikasi ini sudah aktif di pengaturan perangkatmu."
      },
      {
        "question": "Bagaimana menghubungi tim support?",
        "answer":
            "Kamu dapat mengirim email ke support@aplikasi.com atau melalui menu 'Hubungi Kami' di bawah ini."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bantuan"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Pusat Bantuan & FAQ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...faqList.map(
            (faq) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ExpansionTile(
                title: Text(
                  faq["question"]!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      faq["answer"]!,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Membuka halaman Hubungi Kami (belum dibuat)"),
                  ),
                );
              },
              icon: const Icon(Icons.email_outlined),
              label: const Text("Hubungi Kami"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
