class Product {
  final String title;
  final String category;
  final String image;
  final int price;
  final int pages;
  final double rating;
  final int reviews;
  final String description;
  final List<Map<String, String>> bonus;

  Product({
    required this.title,
    required this.category,
    required this.image,
    required this.price,
    required this.pages,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.bonus,
  });
}
