import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
// Not complete, just have basic layout ready for when I am ready to fully implement this
class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  // Fetch products from a stub endpoint
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Map each JSON object to a Product model.
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}