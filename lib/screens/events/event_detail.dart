import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/event_model.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;
  const EventDetailPage({super.key, required this.event});

  static const String waNumber = '62895329205090';

  String _formatRupiah(num? value) {
    if (value == null) return '-';
    final s = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final revIdx = s.length - i;
      buffer.write(s[i]);
      if (revIdx > 1 && revIdx % 3 == 1) buffer.write('.');
    }
    return 'Rp ${buffer.toString()}';
  }

  String _buildMessage() {
    final biaya = _formatRupiah(event.price);
    return [
      'Halo Admin, saya ingin daftar event berikut:',
      '• Judul: ${event.title}',
      '• Tanggal: ${event.date}',
      '• Lokasi: ${event.location}',
      '• Biaya: $biaya',
      '',
      'Deskripsi:',
      event.description,
      '',
      'Mohon info ketersediaan & langkah pembayaran. Terima kasih.',
    ].join('\n');
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final text = Uri.encodeComponent(_buildMessage());
    final schemeUri = Uri.parse('whatsapp://send?phone=$waNumber&text=$text');
    final webUri = Uri.parse('https://wa.me/$waNumber?text=$text');

    final canApp = await canLaunchUrl(schemeUri);
    if (canApp) {
      final ok = await launchUrl(schemeUri, mode: LaunchMode.externalApplication);
      if (ok) return;
    }

    final okWeb = await launchUrl(webUri, mode: LaunchMode.platformDefault);
    if (!okWeb && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hargaLabel = _formatRupiah(event.price);
    final imageUrl = event.image.startsWith('http')
        ? event.image
        : 'http://192.168.1.5:8000/storage/${event.image}'; // sesuaikan base URL

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ====== HEADER GAMBAR ======
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hargaLabel,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ====== INFO ======
            SectionCard(
              title: 'Informasi Event',
              child: Row(
                children: [
                  Expanded(
                    child: InfoBox(
                      icon: Icons.calendar_today,
                      label: 'Tanggal',
                      value: event.date,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoBox(
                      icon: Icons.location_on,
                      label: 'Lokasi',
                      value: event.location,
                      iconColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ====== DESKRIPSI ======
            SectionCard(
              title: 'Deskripsi',
              child: Text(
                event.description,
                style: const TextStyle(fontSize: 15.5, height: 1.45),
              ),
            ),

            const SizedBox(height: 12),

            // ====== TOMBOL WA ======
            SectionCard(
              title: 'Pendaftaran',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Klik tombol di bawah untuk mendaftar via WhatsApp. Pesan akan otomatis berisi detail event.',
                    style: TextStyle(fontSize: 14.5, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.chat),
                    label: const Text('Daftar Event'),
                    onPressed: () => _openWhatsApp(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== KOMPONEN TAMBAHAN ======

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 18,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  const InfoBox({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
