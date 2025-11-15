import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PsikologListPage extends StatefulWidget {
  const PsikologListPage({super.key});

  @override
  State<PsikologListPage> createState() => _PsikologListPageState();
}

class _PsikologListPageState extends State<PsikologListPage> {
  Future<List<dynamic>> fetchPsikologs() async {
    final res = await http.get(Uri.parse('http://127.0.0.1:8000/api/psychologist-schedules'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Gagal memuat data psikolog');
    }
  }

  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _wa(String number) async {
    final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    final intl = digits.startsWith('0') ? '62${digits.substring(1)}' : digits;
    final uri = Uri.parse('https://wa.me/$intl');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Psikolog')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPsikologs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final list = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final p = list[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.withOpacity(.12),
                    child: const Icon(Icons.psychology, color: Colors.teal),
                  ),
                  title: Text(p['nama']),
                  subtitle: Text('${p['lokasi']} • ${p['online'] ? 'Online' : 'Offline'}'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        tooltip: 'Telepon',
                        icon: const Icon(Icons.call, color: Colors.teal),
                        onPressed: () => _call(p['no']),
                      ),
                      IconButton(
                        tooltip: 'WhatsApp',
                        icon: const Icon(Icons.chat, color: Colors.teal),
                        onPressed: () => _wa(p['no']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
