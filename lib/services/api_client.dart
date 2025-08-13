import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _headers();
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
