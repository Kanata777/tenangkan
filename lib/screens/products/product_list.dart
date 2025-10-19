import 'package:flutter/material.dart';
import 'product_detail.dart';
import 'product_model.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  // default posisi tab Produk (kalau dipakai di bottom nav)
  int _selected = 1;

  final List<String> promoBanners = [
    // bebas dulu ya—pakai placeholder Unsplash/Placeholder
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?q=80&w=1600",
    "https://images.unsplash.com/photo-1519455953755-af066f52f1ea?q=80&w=1600",
    "https://via.placeholder.com/1600x600/26a69a/ffffff?text=Promo+E-book+Tenangkan.id",
  ];

  final PageController _bannerCtrl = PageController(viewportFraction: 0.92);
  int _bannerIndex = 0;

  final List<Product> products = [
    Product(
      title: "Mindful Parenting: Mengasuh dengan Kesadaran Penuh",
      category: "Parenting",
      image: "https://images.unsplash.com/photo-1521123845560-14093637aa7a?q=80&w=900",
      price: 79000,
      pages: 156,
      rating: 4.8,
      reviews: 156,
      description: "Panduan lengkap untuk mengasuh anak dengan pendekatan mindfulness.",
      bonus: [
        {"title": "Audio Meditasi Guided", "type": "Audio"},
        {"title": "Kartu Afirmasi Digital", "type": "PDF"},
      ],
    ),
    Product(
      title: "Ibu Kuat Mental: Mengatasi Burnout",
      category: "Kesehatan Mental",
      image: "https://images.unsplash.com/photo-1517249361621-f11084eb8e28?q=80&w=900",
      price: 65000,
      pages: 128,
      rating: 4.8,
      reviews: 127,
      description: "Tips dan strategi untuk menghadapi burnout.",
      bonus: [
        {"title": "E-book Worksheet", "type": "PDF"},
      ],
    ),
  ];

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buf.write('.');
        count = 0;
      }
    }
    return String.fromCharCodes(buf.toString().runes.toList().reversed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Product"),
      ),
      body: Stack(
        children: [
          // 🌊 Background gradient halus
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
          // Konten
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 190,
                  child: PageView.builder(
                    controller: _bannerCtrl,
                    itemCount: promoBanners.length,
                    onPageChanged: (i) => setState(() => _bannerIndex = i),
                    itemBuilder: (context, index) {
                      final url = promoBanners[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: AnimatedBuilder(
                          animation: _bannerCtrl,
                          builder: (context, child) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // 🖼️ Banner image
                                  Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (c, w, p) {
                                      if (p == null) return w;
                                      return Container(
                                        color: Colors.teal.withOpacity(0.06),
                                        child: const Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      );
                                    },
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.teal.withOpacity(0.08),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  // Overlay teks promo bebas
                                  Positioned(
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.35),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "Promo E-book & Kelas • Tenangkan.id",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      height: 6,
                      width: _bannerIndex == i ? 18 : 8,
                      decoration: BoxDecoration(
                        color: _bannerIndex == i ? Colors.teal : Colors.teal.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              // Grid Produk
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final p = products[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                        ),
                        child: Card(
                          elevation: 0.6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar produk
                              AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                      child: Image.network(
                                        p.image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        loadingBuilder: (c, w, pgr) {
                                          if (pgr == null) return w;
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                          );
                                        },
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    // Badge bonus jika ada
                                    if ((p.bonus ?? []).isNotEmpty)
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.teal,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${p.bonus!.length} Bonus",
                                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Info produk
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // kategori
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        p.category,
                                        style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // judul
                                    Text(
                                      p.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                                    ),
                                    const SizedBox(height: 6),
                                    // harga
                                    Text(
                                      "Rp ${_formatRupiah(p.price)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.teal,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // rating + pages
                                    Row(
                                      children: [
                                        const Icon(Icons.star, size: 14, color: Colors.amber),
                                        const SizedBox(width: 2),
                                        Text("${p.rating}"),
                                        const SizedBox(width: 6),
                                        Text("(${p.reviews})", style: TextStyle(color: Colors.grey.shade600)),
                                        const Spacer(),
                                        const Icon(Icons.menu_book, size: 14),
                                        const SizedBox(width: 2),
                                        Text("${p.pages}"),
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
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // (Opsional) tempatkan bottom nav-mu di sini jika diperlukan
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: _selected,
      //   onDestinationSelected: (i) => setState(() => _selected = i),
      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: "Dashboard"),
      //     NavigationDestination(icon: Icon(Icons.library_books_outlined), selectedIcon: Icon(Icons.library_books), label: "Produk"),
      //     NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: "Event"),
      //     NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: "Profil"),
      //   ],
      // ),
    );
  }
}
