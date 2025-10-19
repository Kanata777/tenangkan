import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'product_detail.dart';
import 'product_model.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final List<String> promoBanners = const [
    'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?q=80&w=1600',
    'https://images.unsplash.com/photo-1519455953755-af066f52f1ea?q=80&w=1600',
    'https://via.placeholder.com/1600x600/26a69a/ffffff?text=Promo+E-book+Tenangkan.id',
  ];

  final PageController _bannerCtrl = PageController(viewportFraction: .92);
  int _bannerIndex = 0;

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  String _formatRupiah(int value) {
    final s = value.toString();
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

  @override
  Widget build(BuildContext context) {
    final items = PRODUCTS; // dari product_model.dart

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'Product',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.teal),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // ===== Banner =====
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 190,
                  child: PageView.builder(
                    controller: _bannerCtrl,
                    itemCount: promoBanners.length,
                    onPageChanged: (i) => setState(() => _bannerIndex = i),
                    itemBuilder: (_, i) {
                      final url = promoBanners[i];
                      return Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (c, w, p) => p == null
                                      ? w
                                      : Container(
                                          color: Colors.teal.withOpacity(.06),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.teal.withOpacity(.08),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.35),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Promo E-book & Kelas • Tenangkan.id',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // indikator banner
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    promoBanners.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      height: 6,
                      width: _bannerIndex == i ? 18 : 8,
                      decoration: BoxDecoration(
                        color: _bannerIndex == i
                            ? Colors.teal
                            : Colors.teal.withOpacity(.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              // ===== Masonry Grid (auto height) =====
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childCount: items.length,
                  itemBuilder: (context, index) {
                    final p = items[index];
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: p),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(14),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // gambar buku (boleh tetap pakai rasio agar rapi)
                            AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _SmartImage(p.image),
                                  if (p.bonus.isNotEmpty)
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.card_giftcard,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${p.bonus.length} Bonus',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // info singkat
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // kategori chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(.10),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      p.category,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // judul
                                  Text(
                                    p.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // harga
                                  Text(
                                    _formatRupiah(p.price),
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // rating + pages
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(p.rating.toStringAsFixed(1)),
                                      const SizedBox(width: 6),
                                      Text(
                                        '(${p.reviews})',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.menu_book, size: 14),
                                      const SizedBox(width: 2),
                                      Text('${p.pages}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gambar otomatis: asset (lokal) / URL (network)
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
        loadingBuilder: (c, w, p) => p == null
            ? w
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
        ),
      );
    }
    return Image.asset(
      pathOrUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
      ),
    );
  }
}
