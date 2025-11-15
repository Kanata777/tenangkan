class Event {
  final String id;
  final String title;
  final String category;
  final String image;
  final String date;
  final String location;
  final String description;
  final num price;
  final bool isOnline;
  final String contact;
  final String organizer;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.date,
    required this.location,
    required this.description,
    required this.price,
    required this.isOnline,
    required this.contact,
    required this.organizer,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? 'Umum',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      price: json['ticket_price'] != null
          ? num.tryParse(json['ticket_price'].toString()) ?? 0
          : 0,
      isOnline: json['is_online'] == 1 || json['is_online'] == true,
      contact: json['contact'] ?? '-',
      organizer: json['organizer'] ?? '-',
    );
  }
}
