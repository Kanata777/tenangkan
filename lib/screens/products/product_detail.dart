import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  // Nomor WhatsApp admin (ubah sesuai kebutuhan)
  static const String waNumber = '+62 812-3456-7890';
  static const String waNote =
      'Hai Admin Tenangkan.id, saya tertarik membeli e-book.';

  @override
  Widget build(BuildContext context) {
    // Ganti URL-URL ini dengan halaman preview e-book kamu
    final List<String> previewImages = [
      product.image,
      'https://via.placeholder.com/900x1200?text=Preview+Halaman+1',
      'https://via.placeholder.com/900x1200?text=Preview+Halaman+2',
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("Detail E-Book"),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.teal,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🎯 Hero Section
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image,
                    width: 200,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Chip(
                  label: Text(
                    product.category,
                    style: const TextStyle(color: Colors.teal),
                  ),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  "⭐ ${product.rating}  |  ${product.reviews} ulasan",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 💬 Deskripsi
          _sectionCard(
            title: "Deskripsi",
            content: Text(
              product.description,
              style: const TextStyle(height: 1.5, color: Colors.black87),
            ),
          ),

          // 👀 Pratinjau E-book (di bawah Deskripsi)
          _PreviewSection(images: previewImages),

          // 🎁 Bonus (PILL style) — normalisasi audio -> PDF Prompt AI
          _sectionCard(
            title: "Bonus yang Anda Dapatkan",
            content: Column(
              children: [
                for (final mapped in product.bonus.map((raw) {
                  final title = (raw["title"] ?? "").toString();
                  final type = (raw["type"] ?? "").toString();
                  final isAudio = title.toLowerCase().contains("audio") ||
                      type.toLowerCase().contains("audio");

                  if (isAudio) {
                    return {
                      "title": "Prompt AI ",
                      "type": "PDF",
                      "icon": Icons.picture_as_pdf,
                    };
                  }
                  return {
                    "title": title.isEmpty ? "-" : title,
                    "type": type.isEmpty ? "-" : type,
                    "icon": Icons.insert_drive_file,
                  };
                }))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _BonusPill(
                      title: mapped["title"] as String,
                      subtitle: mapped["type"] as String,
                      icon: mapped["icon"] as IconData,
                    ),
                  ),
              ],
            ),
          ),

          // 📘 Spesifikasi
          _sectionCard(
            title: "Spesifikasi E-book",
            content: Table(
              columnWidths: const {0: IntrinsicColumnWidth()},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _rowSpec("Judul", product.title),
                _rowSpec("Kategori", product.category),
                _rowSpec("Halaman", "${product.pages}"),
                _rowSpec("Format", "PDF"),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),

      // 🔹 Tombol bawah: Hubungi Admin (langsung ke WA)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Rp ${product.price}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () => _openWhatsApp(context),
                label: const Text(
                  "Hubungi Admin",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Row spesifikasi
  TableRow _rowSpec(String key, String value) => TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(key,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(value),
        ),
      ]);

  // 🔹 Section card reusable
  Widget _sectionCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x11000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  // ----------------------------
  // 🔹 Buka WhatsApp dengan pesan template
  // ----------------------------
  Future<void> _openWhatsApp(BuildContext context) async {
    final raw = waNumber.replaceAll(' ', '').replaceAll('+', '');
    final text =
        'Halo Admin Tenangkan.id, saya tertarik e-book: ${product.title} (Rp ${product.price}). ${waNote}';
    final uri = Uri.parse('https://wa.me/$raw?text=${Uri.encodeComponent(text)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // fallback: salin ke clipboard + tampilkan sheet kontak
      await Clipboard.setData(ClipboardData(text: '$waNumber\n\n$text'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak bisa membuka WhatsApp. Nomor & pesan disalin.'),
          ),
        );
        _showContactSheet(context);
      }
    }
  }

  // ----------------------------
  // 🔹 Popup kontak admin (WA) — fallback
  // ----------------------------
  void _showContactSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Hubungi Admin Tenangkan.id",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Chat via WhatsApp untuk pemesanan & pertanyaan.",
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Nomor WA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        waNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          const ClipboardData(text: waNumber),
                        );
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(content: Text("Nomor disalin")),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text("Salin"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Pesan cepat
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Pesan cepat",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.message_outlined, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(child: Text(waNote)),
                    TextButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          const ClipboardData(text: waNote),
                        );
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(content: Text("Pesan disalin")),
                          );
                        }
                      },
                      child: const Text("Salin"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    "Oke, Saya Hubungi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 👀 Section pratinjau E-book (carousel swipe + indikator)
class _PreviewSection extends StatefulWidget {
  final List<String> images;
  const _PreviewSection({required this.images});

  @override
  State<_PreviewSection> createState() => _PreviewSectionState();
}

class _PreviewSectionState extends State<_PreviewSection> {
  int current = 0;
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _sectionCard(
      title: "Pratinjau E-book",
      content: Column(
        children: [
          // rasio buku tinggi
          AspectRatio(
            aspectRatio: 3 / 4.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageCtrl,
                    itemCount: widget.images.length,
                    onPageChanged: (i) => setState(() => current = i),
                    itemBuilder: (_, i) => Image.network(
                      widget.images[i],
                      fit: BoxFit.cover,
                      loadingBuilder: (c, w, e) =>
                          e == null ? w : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image_outlined,
                            size: 48, color: Colors.black26),
                      ),
                    ),
                  ),
                  // panah kiri/kanan
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavArrow(
                          onTap: () {
                            final prev =
                                (current - 1).clamp(0, widget.images.length - 1);
                            _pageCtrl.animateToPage(
                              prev,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                            );
                          },
                          enabled: current > 0,
                        ),
                        _NavArrow(
                          right: true,
                          onTap: () {
                            final next =
                                (current + 1).clamp(0, widget.images.length - 1);
                            _pageCtrl.animateToPage(
                              next,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                            );
                          },
                          enabled: current < widget.images.length - 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // indikator titik
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (i) {
              final active = i == current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: active ? 18 : 8,
                decoration: BoxDecoration(
                  color: active ? Colors.teal : Colors.teal.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Section card lokal agar selaras
  Widget _sectionCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x11000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}

// 🎁 Bonus pill — NON-KLIK, tanpa chevron/unduh
class _BonusPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const _BonusPill({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final pillBg = Colors.grey.shade100;
    const iconBg = Color(0xFFE9F6F3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    )),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // (tidak ada chevron / tombol unduh)
        ],
      ),
    );
  }
}

// 🔘 panah navigasi kecil untuk carousel
class _NavArrow extends StatelessWidget {
  final bool right;
  final bool enabled;
  final VoidCallback onTap;
  const _NavArrow({
    super.key,
    this.right = false,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1 : 0.25,
        child: Container(
          margin: EdgeInsets.only(left: right ? 0 : 6, right: right ? 6 : 0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.18),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                right ? Icons.chevron_right : Icons.chevron_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
