import 'package:flutter/material.dart';
import 'package:tenangkan/widgets/custom_navbar.dart';
import 'package:tenangkan/screens/products/product_list.dart';
import 'package:tenangkan/screens/events/event_list.dart';
import 'package:tenangkan/screens/profile/profile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selected = 0; // index aktif
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _selected);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _pages = [
      const DashboardContent(),
      const ProductsListPage(),
      const EventListPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() => _selected = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selected,
        onTap: (index) {
          setState(() => _selected = index);
          _controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

/// ✅ Isi Dashboard
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"name": "Ibu Rumah Tangga", "icon": Icons.group, "color": Colors.blueAccent},
      {"name": "Ibu & Wanita Karier", "icon": Icons.favorite, "color": Colors.purpleAccent},
      {"name": "Ibu dengan Anak Berkebutuhan Khusus", "icon": Icons.child_care, "color": Colors.green},
      {"name": "Kesehatan Jiwa Anak", "icon": Icons.psychology, "color": Colors.orange},
    ];

    final featuredProducts = [
      {"title": "Produk A", "price": "Gratis", "image": "https://via.placeholder.com/150"},
      {"title": "Produk B", "price": "Rp 150.000", "image": "https://via.placeholder.com/150"},
      {"title": "Produk C", "price": "Rp 200.000", "image": "https://via.placeholder.com/150"},
      {"title": "Produk D", "price": "Gratis", "image": "https://via.placeholder.com/150"},
    ];

    int gridCount(BuildContext ctx) {
      final w = MediaQuery.of(ctx).size.width;
      if (w >= 1000) return 4;
      if (w >= 700) return 3;
      return 2;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.tealAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Selamat datang, Sahabat! 👋",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Yuk, ikuti Kelas Mindfulness Gratis! Temukan ketenangan di tengah kesibukan sebagai ibu.",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 0, 150, 136),
                  ),
                  onPressed: () {},
                  child: const Text("Lihat Kelas Gratis"),
                ),
              ],
            ),
          ),

          // Kategori
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pilih Topik Sesuai Kebutuhanmu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount(context),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: cat["color"] as Color,
                                child: Icon(cat["icon"] as IconData, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cat["name"] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Produk Unggulan
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Produk Unggulan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Lihat Semua", style: TextStyle(color: Colors.teal)),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featuredProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount(context),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = featuredProducts[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 4,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(product["image"] as String, fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product["title"] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product["price"] as String,
                                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
