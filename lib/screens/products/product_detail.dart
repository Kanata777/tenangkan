import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  static const String waNumber = '+62 812-3456-7890';
  static const String waNote =
      'Hai Admin, saya tertarik membeli produk dari Tenangkan.id.';

  @override
  Widget build(BuildContext context) {
    final List<String> previewImages = [
      product.image,
      'https://via.placeholder.com/900x1200?text=Preview+1',
      'https://via.placeholder.com/900x1200?text=Preview+2',
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gambar utama produk
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
                  product.name,
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
                    product.category.isNotEmpty
                        ? product.category
                        : "Umum",
                    style: const TextStyle(color: Colors.teal),
                  ),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatRupiah(product.price),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Deskripsi produk
          _sectionCard(
            title: "Deskripsi Produk",
            content: Text(
              product.description.isNotEmpty
                  ? product.description
                  : 'Belum ada deskripsi untuk produk ini.',
              style: const TextStyle(height: 1.5, color: Colors.black87),
            ),
          ),

          // Pratinjau (jika ingin tampilkan beberapa gambar)
          _PreviewSection(images: previewImages),

          // Spesifikasi produk
          _sectionCard(
            title: "Spesifikasi Produk",
            content: Table(
              columnWidths: const {0: IntrinsicColumnWidth()},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _rowSpec("Nama Produk", product.name),
                _rowSpec("Kategori", product.category),
                _rowSpec("Harga", _formatRupiah(product.price)),
                _rowSpec("Status", product.popularityStatus.isNotEmpty
                    ? product.popularityStatus
                    : 'Normal'),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),

      // Tombol bawah (Hubungi Admin)
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

  // --- Bagian helper ---
  static TableRow _rowSpec(String key, String value) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              key,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87),
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
              color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal)),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final raw = waNumber.replaceAll(' ', '').replaceAll('+', '');
    final text =
        'Halo Admin, saya tertarik membeli produk "${product.name}" dengan harga ${_formatRupiah(product.price)}. $waNote';
    final uri =
        Uri.parse('https://wa.me/$raw?text=${Uri.encodeComponent(text)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      await Clipboard.setData(ClipboardData(text: '$waNumber\n\n$text'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak bisa membuka WhatsApp. Nomor disalin.'),
          ),
        );
      }
    }
  }

  static String _formatRupiah(dynamic value) {
    if (value == null) return 'Rp 0';
    final int intValue = int.tryParse(value.toString()) ?? 0;
    final s = intValue.toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      c++;
      if (c == 3 && i != 0) {
        buf.write('.');
        c = 0;
      }
    }
    return 'Rp ${String.fromCharCodes(buf.toString().runes.toList().reversed)}';
  }
}

/// Widget untuk menampilkan gambar dari Laravel storage
class _SmartImage extends StatelessWidget {
  final String? pathOrUrl;
  const _SmartImage(this.pathOrUrl);

  bool get _isUrl =>
      pathOrUrl != null &&
      (pathOrUrl!.startsWith('http://') || pathOrUrl!.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    if (pathOrUrl == null || pathOrUrl!.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported,
            size: 32, color: Colors.grey),
      );
    }

    final imageUrl =
        _isUrl ? pathOrUrl! : 'http://192.168.1.5:8000/storage/$pathOrUrl';

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child:
            const Icon(Icons.broken_image, size: 32, color: Colors.grey),
      ),
    );
  }
}

/// Carousel preview sederhana
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
      title: "Pratinjau Produk",
      content: Column(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: widget.images.length,
                onPageChanged: (i) => setState(() => current = i),
                itemBuilder: (_, i) => _SmartImage(widget.images[i]),
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
