class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String category;
  final String popularityStatus;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.popularityStatus,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Ganti dengan IP lokal Laravel kamu
    const String baseUrl = 'http://192.168.1.5:8000/storage/';

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Tanpa Nama',
      description: json['description'] ?? '',
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      category: json['category'] ?? 'Lainnya',
      popularityStatus: json['popularity_status'] ?? 'biasa',
      image: json['image'] != null && json['image'].toString().isNotEmpty
          ? '$baseUrl${json['image']}'
          : '',
    );
  }
}
