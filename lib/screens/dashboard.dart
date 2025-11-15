import 'package:flutter/material.dart';
import 'package:tenangkan/widgets/custom_navbar.dart';
import 'package:tenangkan/screens/products/product_list.dart';
import 'package:tenangkan/screens/events/event_list.dart';
import '../../models/event_model.dart';
import 'package:tenangkan/screens/profile/profile.dart';
import 'package:http/http.dart' as http;
import 'package:tenangkan/screens/events/event_detail.dart';
import 'dart:math';
import 'dart:convert';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // (Hero Section dihapus)
            const SizedBox.shrink(),

            // ====== #1 BERITA ======
            const NewsStripSection(),

            const SizedBox(height: 8),

            // ====== #2 EVENT ======
            const EventCarouselSection(),

            // ====== #4 JADWAL PSIKOLOG ======
            const PsychologistScheduleSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/* ===== TOPIC ITEM (GRADIENT ABU-ABU LEMBUT, SIMETRIS) ===== */

class TopicGreyItem extends StatelessWidget {
  final String assetPath; // PNG
  final String label;
  final VoidCallback onTap;
  final bool compact; // untuk ukuran di grid 1 baris

  const TopicGreyItem({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final double bubble = compact ? 56 : 60;
    final double pad = compact ? 8 : 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: bubble,
            height: bubble,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF5F5F5), Color(0xFFEDEDED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFE0E0E0), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(pad),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/* ========================= #1 NEWS STRIP ========================= */

class NewsStripSection extends StatefulWidget {
  const NewsStripSection({super.key});

  @override
  State<NewsStripSection> createState() => _NewsStripSectionState();
}

class _NewsStripSectionState extends State<NewsStripSection> {
  late final Future<List<Map<String, dynamic>>> _futureNews = fetchNews();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<List<Map<String, dynamic>>> fetchNews() async {
    const String baseUrl = 'http://192.168.1.5:8000/api/news';
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded is List
          ? decoded
          : (decoded['data'] ?? []);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Gagal memuat berita (${response.statusCode})');
    }
  }

  @override
  void initState() {
    super.initState();
    // Timer otomatis geser halaman setiap 5 detik
    Future.delayed(const Duration(seconds: 5), autoSlide);
  }

  void autoSlide() async {
    if (!mounted) return;
    final news = await _futureNews;
    if (news.length <= 1) return; // kalau cuma 1, jangan auto-slide

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;

      setState(() {
        _currentPage = (_currentPage + 1) % news.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureNews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat berita:\n${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada berita.'));
        }

        final newsList = snapshot.data!;

        // Jika hanya 1 berita → tampilkan penuh
        if (newsList.length == 1) {
          final n = newsList.first;
          return _buildNewsCard(context, n, screenWidth, fullWidth: true);
        }

        // Jika lebih dari 1 → tampilkan carousel otomatis
        return SizedBox(
          height: 220, // 🔥 Ubah tinggi carousel jadi lebih rendah dari 250
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: newsList.length,
            itemBuilder: (_, i) =>
                _buildNewsCard(context, newsList[i], screenWidth),
          ),
        );
      },
    );
  }

  Widget _buildNewsCard(
    BuildContext context,
    Map<String, dynamic> n,
    double screenWidth, {
    bool fullWidth = false,
  }) {
    final imagePath = n['image'] ?? '';
    final imageUrl = imagePath.startsWith('http')
        ? imagePath
        : 'http://192.168.1.5:8000/storage/$imagePath';

    final content = (n['content'] ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: 200, // 🔥 Tambahkan tinggi container agar lebih rendah
        width: fullWidth ? screenWidth : screenWidth * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🖼️ Gambar berita
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),

            // 🌫️ Gradasi hitam transparan untuk teks
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
            ),

            // 📰 Judul & isi berita
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n['title'] ?? 'Tanpa Judul',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content.isNotEmpty ? content : 'Tanpa ringkasan',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
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

/* ========================= #2 EVENTS ========================= */
class EventCarouselSection extends StatefulWidget {
  const EventCarouselSection({super.key});

  @override
  State<EventCarouselSection> createState() => _EventCarouselSectionState();
}

class _EventCarouselSectionState extends State<EventCarouselSection> {
  PageController? _pageController;
  int _currentIndex = 0;
  List<Event> _events = [];
  bool _isLoading = true;

  static const String apiUrl = 'http://192.168.1.5:8000/api/events';
  static const String imageBaseUrl = 'http://192.168.1.5:8000/storage/';

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
  try {
    final res = await http.get(Uri.parse(apiUrl));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);

      // Pastikan bentuk datanya list
      List<dynamic> dataList = [];

      if (decoded is List) {
        dataList = decoded;
      } else if (decoded is Map && decoded.containsKey('data')) {
        dataList = decoded['data'] as List;
      }

      // Acak dan batasi 3
      dataList.shuffle(Random());
      final events = dataList.map((item) {
        if (item is Map<String, dynamic>) {
          return Event.fromJson(item);
        } else {
          return Event.fromJson(Map<String, dynamic>.from(item));
        }
      }).toList();

      setState(() {
        _events = events.take(3).toList();
        _isLoading = false;
        _pageController = PageController(
          viewportFraction: _events.length == 1 ? 0.95 : 0.9,
        );
      });
    } else {
      setState(() => _isLoading = false);
    }
  } catch (e, st) {
    debugPrint("Error fetching events: $e\n$st");
    setState(() => _isLoading = false);
  }
}


  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Belum ada event tersedia.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      );
    }

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

          // Carousel
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _events.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, i) {
                final e = _events[i];
                final imageUrl = '$imageBaseUrl${e.image}';

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _events.length == 1 ? 8 : 12,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // ✅ Navigasi ke halaman detail aman
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailPage(event: e),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black87, Colors.transparent],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.event,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        e.date,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
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
                                        e.location,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    e.price > 0 ? "Rp${e.price}" : "Gratis",
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
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

          const SizedBox(height: 10),

          if (_events.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _events.length,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentIndex
                        ? Colors.teal
                        : Colors.grey.shade300,
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

class PsychologistScheduleSection extends StatefulWidget {
  const PsychologistScheduleSection({super.key});

  @override
  State<PsychologistScheduleSection> createState() =>
      _PsychologistScheduleSectionState();
}

class _PsychologistScheduleSectionState
    extends State<PsychologistScheduleSection> {
  List<dynamic> _psychologists = [];
  bool _isLoading = true;

  // Ganti dengan URL hosting Laravel kamu
  static const String baseUrl = 'http://192.168.1.5:8000/api/psychologists';
  static const String storageUrl = 'http://192.168.1.5:8000/storage/';

  @override
  void initState() {
    super.initState();
    fetchPsychologists();
  }

  Future<void> fetchPsychologists() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final response = jsonDecode(res.body);
        setState(() {
          _psychologists = response["data"] ?? [];
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data (${res.statusCode})');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_psychologists.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Belum ada jadwal psikolog tersedia."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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

        // List horizontal
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _psychologists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = _psychologists[i];
              final slots =
                  (p["consulhours"] as List?)
                      ?.map((s) => s["jam"] as String)
                      .toList() ??
                  [];
              final statusList = (p["status"] as List?) ?? [];

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(
                            p["avatar"] != null
                                ? "$storageUrl${p["avatar"]}"
                                : 'https://via.placeholder.com/150',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                p["name"] ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                p["spec"] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Status
                              if (statusList.isNotEmpty)
                                Text(
                                  "Status: ${statusList.join(', ')}",
                                  style: TextStyle(
                                    color: statusList.contains("available")
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 11,
                                  ),
                                ),

                              const SizedBox(height: 6),

                              // Label Jam Konsultasi
                              const Text(
                                "Jam Konsultasi:",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Chip menyesuaikan lebar berdasarkan jumlah jam
                              if (slots.isNotEmpty)
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double totalWidth =
                                        constraints.maxWidth;
                                    final double spacing = 6;
                                    final double chipWidth =
                                        (totalWidth -
                                            (spacing * (slots.length - 1))) /
                                        slots.length;

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: slots.map((jam) {
                                        return SizedBox(
                                          width: chipWidth,
                                          child: ActionChip(
                                            label: Text(
                                              jam,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const PsikologListPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
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
