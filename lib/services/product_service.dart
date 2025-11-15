import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tenangkan/models/product_model.dart';

class ProductService {
  // Ganti IP sesuai hasil ipconfig laptop kamu
  final String baseUrl = "https://darkturquoise-hawk-690924.hostingersite.com/api";

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data produk');
    }
  }

  Future<Product> getProductDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Produk tidak ditemukan');
    }
  }
}
