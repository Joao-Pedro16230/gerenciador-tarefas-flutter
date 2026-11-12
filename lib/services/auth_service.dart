import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class AuthService {
  String? _token;

  String? get token => _token;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      _token = data['token'] as String;

      return _token!;
    }

    if (response.statusCode == 401) {
      throw Exception('E-mail ou senha incorretos.');
    }

    if (response.statusCode == 422) {
      throw Exception('Verifique o e-mail e a senha informados.');
    }

    throw Exception(
      'Não foi possível realizar o login. Código: ${response.statusCode}',
    );
  }
}
