import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/category.dart';

class CategoryService {
  final String token;

  CategoryService({required this.token});

  Future<List<Category>> getCategories() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/categories');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((item) => Category.fromJson(item)).toList();
    }

    throw Exception('Erro ao carregar categorias: ${response.statusCode}');
  }
}
