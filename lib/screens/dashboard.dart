import 'package:flutter/material.dart';
import 'package:tenangkan/widgets/custom_navbar.dart';
import 'package:tenangkan/screens/products/product_list.dart';
import 'package:tenangkan/screens/events/event_list.dart';
import 'package:tenangkan/screens/profile/profile.dart';
import 'psikolog_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selected = 0;
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

  void _onTapNav(int index) {
    setState(() => _selected = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _openChatBot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ChatBotSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      DashboardContent(),
      ProductsListPage(),
      EventListPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _selected = i),
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChatBot,
        child: const Icon(Icons.chat_bubble_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selected,
        onTap: _onTapNav,
      ),
    );
  }
}

/* ========================= DASHBOARD CONTENT ========================= */

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  int _gridCount(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w >= 1000) return 4;
    if (w >= 700) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    // === TOPIK (3 kategori tetap, untuk ikon kecil estetik) ===
    final List<Map<String, Object>> topics = [
      {
        "name": "Ibu Rumah Tangga",
        "icon": Icons.home_outlined,
        "color": const Color(0xFF6C63FF),
      },
      {
        "name": "Ibu & Wanita Karier",
        "icon": Icons.work_outline,
        "color": const Color(0xFFE91E63),
      },
      {
        "name": "Ibu dgn Anak Kebutuhan Khusus",
        "icon": Icons.diversity_3_outlined,
        "color": const Color(0xFF2E7D32),
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== HERO ======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hai, Sahabat 👋",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Ambil jeda sebentar. Ini rekomendasi untukmu hari ini.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // ====== #1 BERITA ======
            const NewsStripSection(),

            // ====== TOPIK: ikon kecil estetik (seperti layanan konseling) ======
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: const Text(
                "Topik",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 108,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final t = topics[index];
                  return TopicServiceItem(
                    icon: t["icon"] as IconData,
                    label: t["name"] as String,
                    color: t["color"] as Color,
                    onTap: () => Navigator.pushNamed(context, '/products'),
                  );
                },
              ),
            ),

            // ====== #2 EVENT (offline & berbayar) ======
            const EventCarouselSection(),

            // ====== #4 JADWAL PSIKOLOG ======
            const PsychologistScheduleSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/* ========================= TOPIC ITEM (ikon kecil) ========================= */

class TopicServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const TopicServiceItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color.withOpacity(.12);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(.25)),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.black.withOpacity(.05)),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/* ========================= #1 NEWS STRIP ========================= */

class NewsStripSection extends StatelessWidget {
  const NewsStripSection({super.key});

  static const List<Map<String, String>> _news = [
    {
      "id": "n1",
      "title": "5 Menit Mindfulness untuk Ibu Sibuk",
      "summary": "Latihan napas sederhana yang bisa kamu lakukan kapan saja.",
      "cover": "https://picsum.photos/seed/tenangkan1/800/500",
    },
    {
      "id": "n2",
      "title": "Cara Mengelola Rasa Bersalah sebagai Ibu",
      "summary": "Tips praktis agar kamu lebih welas asih pada diri sendiri.",
      "cover": "https://picsum.photos/seed/tenangkan2/800/500",
    },
    {
      "id": "n3",
      "title": "Istirahat Mikro di Tengah Pekerjaan",
      "summary": "3 jeda mini untuk karier yang tetap mindful.",
      "cover": "https://picsum.photos/seed/tenangkan3/800/500",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        scrollDirection: Axis.horizontal,
        itemCount: _news.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final n = _news[i];
          return SizedBox(
            width: MediaQuery.of(context).size.width * .78,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(n["cover"]!, fit: BoxFit.cover),
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
                          n["title"]!,
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
                          n["summary"]!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
          );
        },
      ),
    );
  }
}

/* ========================= #2 EVENTS ========================= */

class EventCarouselSection extends StatefulWidget {
  const EventCarouselSection({super.key});

  @override
  State<EventCarouselSection> createState() => _EventCarouselSectionState();
}

class _EventCarouselSectionState extends State<EventCarouselSection> {
  final _pc = PageController(viewportFraction: .9);
  int _index = 0;

  final List<Map<String, String>> events = const [
    {
      'id': 'evt-1',
      'title': 'Trekking for Healing',
      'date': 'Sel, 19 Ags • 07.00',
      'location': 'Tawangmangu',
      'price': 'Rp120.000',
      'image': 'https://picsum.photos/seed/ev21/900/500',
    },
    {
      'id': 'evt-2',
      'title': 'Ruang Jeda: Mindful Walk',
      'date': 'Sab, 12 Okt • 10.00',
      'location': 'Solo Car Free Day',
      'price': 'Rp75.000',
      'image': 'https://picsum.photos/seed/ev22/900/500',
    },
    {
      'id': 'evt-3',
      'title': 'Sharing Circle Ibu Karier',
      'date': 'Min, 20 Okt • 09.00',
      'location': 'Tenangkan Space',
      'price': 'Rp95.000',
      'image': 'https://picsum.photos/seed/ev23/900/500',
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
              "Event",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pc,
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
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.place,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        "${e['date']} • ${e['location']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    e['price']!,
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
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

/* ========================= #4 PSYCHOLOGIST SCHEDULE ========================= */

class PsychologistScheduleSection extends StatelessWidget {
  const PsychologistScheduleSection({super.key});

  static const List<Map<String, Object>> _list = [
    {
      "id": "p1",
      "name": "dr. Rani, M.Psi",
      "spec": "Anxiety • Parenting",
      "rating": "4.9",
      "avatar": "https://picsum.photos/seed/psy1/200/200",
      "slots": ["09:00", "13:00", "16:00"],
    },
    {
      "id": "p2",
      "name": "Bagas, S.Psi",
      "spec": "Relationship • Karier",
      "rating": "4.8",
      "avatar": "https://picsum.photos/seed/psy2/200/200",
      "slots": ["10:00", "14:30"],
    },
    {
      "id": "p3",
      "name": "Nadia, M.Psi",
      "spec": "ABK • Keluarga",
      "rating": "4.9",
      "avatar": "https://picsum.photos/seed/psy3/200/200",
      "slots": ["08:30", "11:00", "15:30"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Jadwal Psikolog",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PsikologListPage()),
                ),
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = _list[i];
              return SizedBox(
                width: 260,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(p["avatar"] as String),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                p["name"] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p["spec"] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                children: (p["slots"] as List<String>)
                                    .take(3)
                                    .map((s) {
                                      return ActionChip(
                                        label: Text(s),
                                        onPressed: () {
                                          // langsung masuk flow booking
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const PsikologListPage(),
                                            ),
                                          );
                                        },
                                      );
                                    })
                                    .toList(),
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
      ],
    );
  }
}

/* ========================= CHATBOT SHEET ========================= */

class ChatBotSheet extends StatefulWidget {
  const ChatBotSheet({super.key});

  @override
  State<ChatBotSheet> createState() => _ChatBotSheetState();
}

class _ChatBotSheetState extends State<ChatBotSheet> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"role": "bot", "text": "Halo! Skala stres kamu hari ini 1–10?"},
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({"role": "user", "text": text});
      _messages.add({
        "role": "bot",
        "text": "Terima kasih. Coba latihan napas 5 menit ya. Mau tips cepat?",
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, scroll) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 56,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.psychology_alt_outlined)),
              title: Text("Temani Kamu Hari Ini"),
              subtitle: Text("Chat-bot pendamping. Bukan pengganti terapi."),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: ScrollController(),
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  final isUser = m["role"] == "user";
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .78,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.teal : const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        m["text"]!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Tulis pesan…",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          isDense: true,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.send),
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/* ========================= DETAIL PAGE ========================= */

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
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 16, color: Colors.teal),
              const SizedBox(width: 6),
              Text(
                event['location']!,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.sell_outlined, size: 16, color: Colors.teal),
              const SizedBox(width: 6),
              Text(
                event['price']!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Deskripsi singkat event. Jelaskan tujuan, manfaat, dan detail teknis (meeting point, perlengkapan, durasi).",
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: arahkan ke halaman checkout/QR tiket
            },
            icon: const Icon(Icons.event_available),
            label: const Text("Daftar Sekarang"),
          ),
        ],
      ),
    );
  }
}
