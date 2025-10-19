class Product {
  final String id;
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
    required this.id,
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

// ====== DATA PRODUK (5 item) ======
final List<Product> PRODUCTS = [
  Product(
    id: 'p1',
    title: 'Menemukan Tenang lewat Doa & Iman',
    category: 'Ibu Rumah Tangga',
    image: 'assets/products/ebook_iman.png',
    price: 79000,
    pages: 158,
    rating: 4.8,
    reviews: 156,
    description:
        'Panduan melepas stres dengan pendekatan doa & iman. Praktik harian yang hangat dan realistis.',
    bonus: [
      {'title': 'Audio Dzikir Pagi', 'desc': 'MP3 10 menit'},
      {'title': 'Template Jurnal Syukur', 'desc': 'PDF cetak'},
    ],
  ),
  Product(
    id: 'p2',
    title: 'Stress Release untuk Wanita Karier',
    category: 'Ibu & Wanita Karier',
    image: 'assets/products/ebook_wanita_karier.png',
    price: 65000,
    pages: 142,
    rating: 4.8,
    reviews: 127,
    description:
        'Strategi singkat mengelola tekanan kerja tanpa kehilangan diri sendiri.',
    bonus: [
      {'title': 'Worksheet Prioritas', 'desc': 'PDF interaktif'},
    ],
  ),
  Product(
    id: 'p3',
    title: 'Kesehatan Jiwa Anak: Panduan Ibu',
    category: 'Ibu dgn Anak Kebutuhan Khusus',
    image: 'assets/products/ebook_kesehatan_jiwa_anak.png',
    price: 69000,
    pages: 136,
    rating: 4.7,
    reviews: 98,
    description:
        'Dasar-dasar kesehatan jiwa anak & komunikasi penuh empati untuk orang tua.',
    bonus: [
      {'title': 'Checklist Sinyal Emosi', 'desc': 'Poster PDF'},
    ],
  ),
  Product(
    id: 'p4',
    title: 'Super Mom ABK: Tenang Menghadapi Drama',
    category: 'Ibu dgn Anak Kebutuhan Khusus',
    image: 'assets/products/ebook_super_mom_abk.png',
    price: 75000,
    pages: 168,
    rating: 4.9,
    reviews: 142,
    description:
        'Teknik praktis menenangkan diri ketika menghadapi drama harian ABK.',
    bonus: [
      {'title': 'Script Komunikasi', 'desc': 'Situasi umum'},
      {'title': 'Audio Napas 5 Menit', 'desc': 'MP3 panduan'},
    ],
  ),
  Product(
    id: 'p5',
    title: 'Seimbang antara Pekerjaan & Keluarga',
    category: 'Ibu & Wanita Karier',
    image: 'assets/products/ebook_work_life_balance.png',
    price: 72000,
    pages: 150,
    rating: 4.8,
    reviews: 131,
    description:
        'Framework ringan menjaga keseimbangan kerja–rumah dengan mindful routine.',
    bonus: [
      {'title': 'Planner Mingguan', 'desc': 'PDF'},
    ],
  ),
];
