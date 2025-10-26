import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'event_model.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  /// Ganti dengan nomor admin (format internasional tanpa +, spasi, atau tanda baca).
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
    final biaya = _formatRupiah(
      (event as dynamic).price ?? (event as dynamic).fee ?? (event as dynamic).biaya,
    );

    return [
      'Halo Admin, saya ingin daftar event berikut:',
      '• Judul: ${event.title}',
      if ((event as dynamic).date != null) '• Tanggal: ${(event as dynamic).date}',
      if ((event as dynamic).location != null) '• Lokasi: ${(event as dynamic).location}',
      '• Biaya: $biaya',
      '• Gambar: ${event.image}',
      '',
      'Keterangan:',
      event.description,
      '',
      'Mohon info ketersediaan & langkah pembayaran. Terima kasih.',
    ].join('\n');
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final text = Uri.encodeComponent(_buildMessage());
    final schemeUri = Uri.parse('whatsapp://send?phone=$waNumber&text=$text');
    final webUri    = Uri.parse('https://wa.me/$waNumber?text=$text');

    // 1) Coba app (mobile only akan true)
    final canApp = await canLaunchUrl(schemeUri);
    if (canApp) {
      final ok = await launchUrl(schemeUri, mode: LaunchMode.externalApplication);
      if (ok) return;
      // kalau gagal, lanjut ke web
    }

    // 2) Fallback ke web (lebih universal)
    final okWeb = await launchUrl(webUri, mode: LaunchMode.platformDefault);
    if (!okWeb && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = (event as dynamic).price ?? (event as dynamic).fee ?? (event as dynamic).biaya;
    final hargaLabel = _formatRupiah(price);

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ====== HEADER GAMBAR + BADGE HARGA ======
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
                        event.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    // gradient bawah agar judul kontras
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
                    // judul di bawah kiri
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
                          height: 1.2,
                        ),
                      ),
                    ),
                    // badge harga di pojok atas
                    if (price != null)
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
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ====== KARTU INFO (TANGGAL & LOKASI) ======
            SectionCard(
              title: 'Informasi Event',
              child: Row(
                children: [
                  Expanded(
                    child: InfoBox(
                      icon: Icons.calendar_today,
                      label: 'Tanggal',
                      value: (event as dynamic).date ?? '-',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoBox(
                      icon: Icons.location_on,
                      label: 'Lokasi',
                      value: (event as dynamic).location ?? '-',
                      iconColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ====== KARTU DESKRIPSI ======
            SectionCard(
              title: 'Deskripsi',
              child: Text(
                event.description,
                style: const TextStyle(fontSize: 15.5, height: 1.45),
              ),
            ),

            const SizedBox(height: 12),

            // ====== KARTU AKSI (TOMBOL WA) ======
            SectionCard(
              title: 'Pendaftaran',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Klik tombol di bawah untuk mendaftar via WhatsApp. Pesan akan terisi otomatis berisi judul, gambar, keterangan, dan biaya.',
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

/// ====== W I D G E T   R E U S A B L E ======

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
          // header kecil
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
              Text(title, style: titleStyle),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.5,
                    )),
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
