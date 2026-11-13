import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/tag.dart';

class TagService {
  final String token;

  TagService({required this.token});

  Future<List<Tag>> getTags() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/tags');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((item) => Tag.fromJson(item)).toList();
    }

    throw Exception('Erro ao carregar etiquetas: ${response.statusCode}');
  }
}
