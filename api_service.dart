import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://us-central1-clone-bf639.cloudfunctions.net';

  // Get all products
  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/getProducts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Get a single product by ID
  static Future<Map<String, dynamic>> getProduct(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/getProduct/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Product not found');
    }
  }

  // Create a new product (admin only)
  static Future<void> createProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createProduct'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  // User login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  // User registration
  static Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }
}