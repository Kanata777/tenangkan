import 'package:flutter/material.dart';
import 'product_detail.dart';
import 'product_model.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  int _selected = 1; // default posisi tab Produk

  final List<Product> products = [
    Product(
      title: "Mindful Parenting: Mengasuh dengan Kesadaran Penuh",
      category: "Parenting",
      image: "https://via.placeholder.com/300x400",
      price: 79000,
      pages: 156,
      rating: 4.8,
      reviews: 156,
      description:
          "Panduan lengkap untuk mengasuh anak dengan pendekatan mindfulness.",
      bonus: [
        {"title": "Audio Meditasi Guided", "type": "Audio"},
        {"title": "Kartu Afirmasi Digital", "type": "PDF"},
      ],
    ),
    Product(
      title: "Ibu Kuat Mental: Mengatasi Burnout",
      category: "Kesehatan Mental",
      image: "https://via.placeholder.com/300x400",
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produk")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final p = products[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(p.image, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          label: Text(p.category,
                              style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.teal.withOpacity(0.1),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Rp ${p.price}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.amber),
                            Text("${p.rating}"),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),

      // ✅ Tambahin Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 14,
                  offset: Offset(0, 6),
                  color: Color(0x19000000),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: NavigationBar(
                height: 64,
                backgroundColor: Colors.white,
                indicatorColor: Colors.teal.withOpacity(.12),
                selectedIndex: _selected,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (i) {
                  setState(() => _selected = i);
                  if (i == 0) {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  } else if (i == 1) {
                    // halaman produk sendiri → tidak perlu apa2
                  } else if (i == 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Halaman Event belum ada')),
                    );
                  } else if (i == 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Halaman Profil belum ada')),
                    );
                  }
                },
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Dashboard'),
                  NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: 'Produk'),
                  NavigationDestination(
                      icon: Icon(Icons.event_outlined),
                      selectedIcon: Icon(Icons.event),
                      label: 'Event'),
                  NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profil'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
