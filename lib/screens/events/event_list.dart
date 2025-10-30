import 'package:flutter/material.dart';
import 'event_detail.dart';
import 'event_model.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    // Animasi masuk ringan untuk seluruh grid (tanpa paket tambahan)
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  String _formatRupiah(num value) {
    final s = value.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final revIdx = s.length - i;
      buf.write(s[i]);
      if (revIdx > 1 && revIdx % 3 == 1) buf.write('.');
    }
    return 'Rp ${buf.toString()}';
  }

  // >>>> PERHATIKAN: isi semua field required sesuai event_model.dart yang sudah dilengkapi
  final List<Event> events = [
    Event(
      id: 'evt-001',
      title: "Show Your Brain Dump",
      category: "Parenting",
      image: "assets/event/showyour.png",
      date: "Rabu, 10 September 2025",
      location: "Rajawali Ceria Daycare, Klodran",
      description:
          "mengajak peserta untuk melepaskan beban pikiran dan emosi yang menumpuk melalui metode Brain Dump, yaitu menuliskan semua isi pikiran secara jujur tanpa filter. Dalam suasana aman dan suportif, peserta diajak untuk release, talk & hug, serta menikmati waktu jeda bersama komunitas yang saling memahami.",
      price: 20000, // wajib
      isOnline: false, // optional
      contact: "62895329205090",
      organizer: "Seimbang Academy",
    ),
    Event(
      id: 'evt-002',
      title: "TREKKING FOR HEALING",
      category: "Kesehatan",
      image: "assets/event/treking.png",
      date: "Selasa, 19 Agustus 2025. 07.30 - 12.00 WIB",
      location: "asecamp Kali Talang, Balerante Klaten",
      description:
          "kalian akan diajak menikmati keindahan alam, perjuangan mencapai puncak, dan mendapati momen penyembuhan diri dalam setiap langkahnya. PERKAP YANG HARUS DIBAWA - Air Mineral- ⁠Snack / Bekal pribadi- ⁠P3K- ⁠Menggunakan sepatu dan pakaian yg nyaman",
      price: 45000,
      isOnline: false,
      contact: "081226952030",
      organizer: "Rona Marisca",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Event"),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _fade.drive(
            Tween(begin: const Offset(0, .03), end: Offset.zero),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final e = events[index];
              return _EventCard(
                event: e,
                formatRupiah: _formatRupiah,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EventDetailPage(event: e)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// ===============
///  CARD WIDGET
/// ===============
class _EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback onTap;
  final String Function(num) formatRupiah;

  const _EventCard({
    required this.event,
    required this.onTap,
    required this.formatRupiah,
  });

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _pressed = false;

  void _setPressed(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final e = widget.event;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ]
                : [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar + badge harga + HERO
              AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: e.id, // sinkron dengan detail
                        child: _FadeInNetworkImage(url: e.image),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Hero(
                          tag: '${e.id}-price',
                          flightShuttleBuilder: _badgeShuttle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.formatRupiah(e.price),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      label: Text(
                        e.category,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                    const SizedBox(height: 4),
                    Hero(
                      tag: '${e.id}-title',
                      flightShuttleBuilder: _textShuttle,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          e.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            e.date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            e.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============
///  UTIL WIDGETS
/// ===============
class _FadeInNetworkImage extends StatelessWidget {
  final String url;
  const _FadeInNetworkImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.grey.shade200),
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        );
      },
      errorBuilder: (_, __, ___) =>
          Container(color: Colors.grey.shade200), // fallback sederhana
    );
  }
}

// Hero flight untuk badge: biar tetap solid & konsisten
Widget _badgeShuttle(BuildContext context, Animation<double> anim,
    HeroFlightDirection dir, BuildContext from, BuildContext to) {
  return FadeTransition(
    opacity: anim,
    child: dir == HeroFlightDirection.push ? from.widget : to.widget,
  );
}

// Hero flight untuk teks agar antialias halus
Widget _textShuttle(BuildContext context, Animation<double> anim,
    HeroFlightDirection dir, BuildContext from, BuildContext to) {
  return FadeTransition(
    opacity: anim,
    child: dir == HeroFlightDirection.push ? to.widget : from.widget,
  );
}
