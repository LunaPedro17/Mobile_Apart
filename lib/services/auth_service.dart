import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token']; // <-- Asumiendo que la API devuelve {"token": "..."}
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
