import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PsikologListPage extends StatelessWidget {
  const PsikologListPage({super.key});

  // ====== DATA DUMMY (bisa ganti dari API/JSON) ======
  List<Map<String, dynamic>> get _psikologs => [
    {
      'nama': 'dr. Sinta, Sp.KJ',
      'no': '081212345678',
      'lokasi': 'Solo',
      'online': true,
    },
    {
      'nama': 'Maya, M.Psi., Psikolog',
      'no': '081355559999',
      'lokasi': 'Jakarta',
      'online': true,
    },
    {
      'nama': 'Rizky, M.Psi., Psikolog',
      'no': '081777772222',
      'lokasi': 'Yogyakarta',
      'online': false,
    },
  ];

  // ====== ACTIONS ======
  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _wa(String number) async {
    // normalisasi: 08xxxx -> 62xxxx (untuk link WhatsApp)
    final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    final intl = digits.startsWith('0') ? '62${digits.substring(1)}' : digits;
    final uri = Uri.parse('https://wa.me/$intl');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _psikologs;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kontak Psikolog')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final Map<String, dynamic> p = list[i];

          final String nama = p['nama'] as String;
          final String no = p['no'] as String;
          final String lokasi = p['lokasi'] as String;
          final bool online = p['online'] as bool;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.withOpacity(.12),
                child: const Icon(Icons.psychology, color: Colors.teal),
              ),
              title: Text(nama),
              subtitle: Text('$lokasi • ${online ? 'Online' : 'Offline'}'),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    tooltip: 'Telepon',
                    icon: const Icon(Icons.call, color: Colors.teal),
                    onPressed: () => _call(no),
                  ),
                  IconButton(
                    tooltip: 'WhatsApp',
                    icon: const Icon(Icons.chat, color: Colors.teal),
                    onPressed: () => _wa(no),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
