import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  // WA admin (ubah sesuai kebutuhan)
  static const String waNumber = '+62 812-3456-7890';
  static const String waNote =
      'Hai Admin Tenangkan.id, saya tertarik membeli e-book.';

  @override
  Widget build(BuildContext context) {
    // Jika kamu belum punya preview halaman, biarkan cover muncul berulang.
    final List<String> previewImages = [
      product.image, // cover (asset)
      // kamu boleh ganti 2 baris di bawah menjadi asset lain / URL preview
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
          // HERO
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
                  child: SizedBox(
                    width: 200,
                    height: 260,
                    child: _SmartImage(product.image),
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
                  "⭐ ${product.rating.toStringAsFixed(1)}  |  ${product.reviews} ulasan",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // DESKRIPSI
          _sectionCard(
            title: "Deskripsi",
            content: Text(
              product.description,
              style: const TextStyle(height: 1.5, color: Colors.black87),
            ),
          ),

          // PRATINJAU
          _PreviewSection(images: previewImages),

          // BONUS
          _sectionCard(
            title: "Bonus yang Anda Dapatkan",
            content: Column(
              children: [
                for (final b in product.bonus)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _BonusPill(
                      title: (b['title'] ?? '-').toString(),
                      subtitle: (b['desc'] ?? '-').toString(),
                      icon: _pickBonusIcon((b['desc'] ?? '').toLowerCase()),
                    ),
                  ),
                if (product.bonus.isEmpty)
                  const Text(
                    "Belum ada bonus tambahan.",
                    style: TextStyle(color: Colors.black54),
                  ),
              ],
            ),
          ),

          // SPESIFIKASI
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

      // CTA BAWAH
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
                _formatRupiah(product.price),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
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

  // -------- helpers (section/spec/wa/format/icon) --------

  TableRow _rowSpec(String key, String value) => TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          key,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(value),
      ),
    ],
  );

  static Widget _sectionCard({required String title, required Widget content}) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final raw = waNumber.replaceAll(' ', '').replaceAll('+', '');
    final text =
        'Halo Admin Tenangkan.id, saya tertarik e-book: ${product.title} (${_formatRupiah(product.price)}). $waNote';
    final uri = Uri.parse(
      'https://wa.me/$raw?text=${Uri.encodeComponent(text)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      await Clipboard.setData(ClipboardData(text: '$waNumber\n\n$text'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak bisa membuka WhatsApp. Nomor & pesan disalin.',
            ),
          ),
        );
        _showContactSheet(context);
      }
    }
  }

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

              // nomor
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

              // pesan
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pesan cepat",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                      horizontal: 24,
                      vertical: 14,
                    ),
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

  String _formatRupiah(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write('.');
    }
    return 'Rp $b';
  }

  IconData _pickBonusIcon(String desc) {
    if (desc.contains('audio') || desc.contains('mp3')) return Icons.audiotrack;
    if (desc.contains('pdf')) return Icons.picture_as_pdf;
    if (desc.contains('doc')) return Icons.description_outlined;
    return Icons.insert_drive_file;
  }
}

/* ------------ Widget util: gambar asset ATAU URL otomatis ------------ */

class _SmartImage extends StatelessWidget {
  final String pathOrUrl;
  const _SmartImage(this.pathOrUrl);

  bool get _isUrl =>
      pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isUrl) {
      return Image.network(
        pathOrUrl,
        fit: BoxFit.cover,
        loadingBuilder: (c, w, e) =>
            e == null ? w : const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.black26,
          ),
        ),
      );
    }
    return Image.asset(
      pathOrUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: Colors.black26,
        ),
      ),
    );
  }
}

/// Section pratinjau (carousel)
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
    return ProductDetailPage._sectionCard(
      title: "Pratinjau E-book",
      content: Column(
        children: [
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
                    itemBuilder: (_, i) => _SmartImage(widget.images[i]),
                  ),
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavArrow(
                          onTap: () {
                            final prev = (current - 1).clamp(
                              0,
                              widget.images.length - 1,
                            );
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
                            final next = (current + 1).clamp(
                              0,
                              widget.images.length - 1,
                            );
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
}

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
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
