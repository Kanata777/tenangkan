class Event {
  final String id;          // ID unik event
  final String title;       // Judul event
  final String category;    // Kategori (seminar, lomba, konser, dll)
  final String image;       // URL gambar/banner event
  final String date;        // Tanggal event
  final String location;    // Lokasi event
  final String description; // Deskripsi event
  final int price;          // Biaya pendaftaran (dalam rupiah)
  final bool isOnline;      // True = event online, False = offline
  final String contact;     // Kontak panitia (opsional)
  final String organizer;   // Nama penyelenggara

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.date,
    required this.location,
    required this.description,
    required this.price,
    this.isOnline = false,
    this.contact = '',
    this.organizer = '',
  });

  /// dari JSON → object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      isOnline: json['isOnline'] ?? false,
      contact: json['contact'] ?? '',
      organizer: json['organizer'] ?? '',
    );
  }

  /// ke JSON → Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'image': image,
      'date': date,
      'location': location,
      'description': description,
      'price': price,
      'isOnline': isOnline,
      'contact': contact,
      'organizer': organizer,
    };
  }
}
