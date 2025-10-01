import 'package:flutter/material.dart';
import 'psikolog_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selected = 0; // 0: Dashboard, 1: Produk, 2: Event, 3: Profil

  final List<Map<String, dynamic>> categories = [
    {
      "name": "Ibu Rumah Tangga",
      "icon": Icons.group,
      "color": Colors.blueAccent,
    },
    {
      "name": "Ibu & Wanita Karier",
      "icon": Icons.favorite,
      "color": Colors.purpleAccent,
    },
    {
      "name": "Ibu dengan Anak Berkebutuhan Khusus",
      "icon": Icons.child_care,
      "color": Colors.green,
    },
    {
      "name": "Kesehatan Jiwa Anak",
      "icon": Icons.psychology,
      "color": Colors.orange,
    },
  ];

  int gridCount(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w >= 1000) return 4;
    if (w >= 700) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                      foregroundColor: Colors.teal,
                    ),
                    onPressed: () {},
                    child: const Text("Lihat Kelas Gratis"),
                  ),
                ],
              ),
            ),

            // KATEGORI
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
                          onTap: () {
                            // TODO: arahkan ke /produk dengan filter sesuai topik
                            Navigator.pushNamed(context, '/produk');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: (cat["color"] as Color)
                                      .withOpacity(.18),
                                  child: Icon(cat["icon"], color: cat["color"]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cat["name"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
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

            // CAROUSEL EVENT
            const EventCarouselSection(),

            // CONTACT PSIKOLOG
            const ContactPsikologSection(),

            const SizedBox(height: 80), // supaya tidak tertutup navbar
          ],
        ),
      ),

      // NAVBAR (tetap)
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
                  if (i == 1) {
                    Navigator.pushNamed(context, '/produk');
                  } else if (i == 2) {
                    Navigator.pushNamed(context, '/event');
                  } else if (i == 3) {
                    Navigator.pushNamed(context, '/profil');
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.menu_book_outlined),
                    selectedIcon: Icon(Icons.menu_book),
                    label: 'Produk',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.event_outlined),
                    selectedIcon: Icon(Icons.event),
                    label: 'Event',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ========================= SECTIONS ========================= */

class EventCarouselSection extends StatefulWidget {
  const EventCarouselSection({super.key});

  @override
  State<EventCarouselSection> createState() => _EventCarouselSectionState();
}

class _EventCarouselSectionState extends State<EventCarouselSection> {
  final _pc = PageController(viewportFraction: .9);
  int _index = 0;

  final List<Map<String, String>> events = [
    {
      'id': 'evt-1',
      'title': 'Ruang Jeda: Mindfulness for Moms',
      'date': 'Sab, 12 Okt • 10.00',
      'image': 'https://picsum.photos/seed/21/900/500',
    },
    {
      'id': 'evt-2',
      'title': 'Healing & Sharing Circle',
      'date': 'Min, 20 Okt • 09.00',
      'image': 'https://picsum.photos/seed/22/900/500',
    },
    {
      'id': 'evt-3',
      'title': 'Meditasi Nafas 10 Menit',
      'date': 'Setiap Hari • Fleksibel',
      'image': 'https://picsum.photos/seed/23/900/500',
    },
  ];

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Event RuangJedaKita",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pc,
              physics: const PageScrollPhysics(), // <— pastikan ini ada
              itemCount: events.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final e = events[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailPage(event: e),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(e['image']!, fit: BoxFit.cover),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black54, Colors.transparent],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e['title']!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  e['date']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              events.length,
              (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _index ? Colors.teal : const Color(0xFFE0E0E0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactPsikologSection extends StatelessWidget {
  const ContactPsikologSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PsikologListPage()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: Colors.teal,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Psikolog",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Butuh bantuan profesional? Lihat daftar psikolog & nomor kontak.",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ========================= PAGES ========================= */

class EventDetailPage extends StatelessWidget {
  final Map<String, String> event;
  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Event')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              event['image']!,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event['title']!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.teal,
              ),
              const SizedBox(width: 6),
              Text(
                event['date']!,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Deskripsi singkat event. Jelaskan tujuan, manfaat, dan cara ikut serta. "
            "Tambahkan tombol daftar atau link eksternal jika perlu.",
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.event_available),
            label: const Text("Daftar Sekarang"),
          ),
        ],
      ),
    );
  }
}
