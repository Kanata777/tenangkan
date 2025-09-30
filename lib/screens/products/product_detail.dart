import 'package:flutter/material.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(product.image,
                  width: 180, height: 240, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(product.category),
            backgroundColor: Colors.teal.withOpacity(0.1),
          ),
          const SizedBox(height: 8),
          Text(product.title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.menu_book, size: 16),
              const SizedBox(width: 4),
              Text("${product.pages} halaman"),
              const SizedBox(width: 16),
              const Icon(Icons.picture_as_pdf, size: 16),
              const SizedBox(width: 4),
              const Text("PDF"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              Text("${product.rating} (${product.reviews} review)"),
            ],
          ),
          const SizedBox(height: 12),
          Text("Rp ${product.price}",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal)),
          const Divider(height: 32),

          // Deskripsi
          const Text("Deskripsi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(product.description),
          const Divider(height: 32),

          // Bonus
          const Text("Bonus yang Anda Dapatkan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Column(
            children: product.bonus
                .map((b) => ListTile(
                      leading: const Icon(Icons.download),
                      title: Text(b["title"]!),
                      subtitle: Text(b["type"]!),
                    ))
                .toList(),
          ),
          const Divider(height: 32),

          // Spesifikasi E-book
          const Text("Spesifikasi E-book",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Table(
            children: [
              TableRow(children: [
                const Text("Judul"),
                Text(product.title),
              ]),
              TableRow(children: [
                const Text("Kategori"),
                Text(product.category),
              ]),
              TableRow(children: [
                const Text("Jumlah Halaman"),
                Text("${product.pages}"),
              ]),
              TableRow(children: [
                const Text("Format"),
                const Text("PDF"),
              ]),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rp ${product.price}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  backgroundColor: Colors.teal),
              onPressed: () {
                // TODO: Integrasi ke pembayaran
              },
              child: const Text("Beli Sekarang"),
            )
          ],
        ),
      ),
    );
  }
}
