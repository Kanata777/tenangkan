import 'package:flutter/material.dart';
import 'event_detail.dart';
import 'event_model.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final List<Event> events = [
    Event(
      title: "Workshop Mindfulness untuk Ibu",
      category: "Parenting",
      image: "https://via.placeholder.com/300x400",
      date: "12 Okt 2025",
      location: "Jakarta",
      description:
          "Acara workshop untuk meningkatkan kesadaran penuh dalam mengasuh anak.",
    ),
    Event(
      title: "Seminar Kesehatan Mental",
      category: "Kesehatan",
      image: "https://via.placeholder.com/300x400",
      date: "25 Okt 2025",
      location: "Bandung",
      description:
          "Belajar strategi mengatasi burnout dan menjaga kesehatan mental.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Event"),
      ),
      body: GridView.builder(
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
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventDetailPage(event: e)),
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
                      child: Image.network(e.image, fit: BoxFit.cover),
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
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.date,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.redAccent,
                            ),
                            Flexible(
                              child: Text(
                                e.location,
                                overflow: TextOverflow.ellipsis,
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
          );
        },
      ),
    );
  }
}
