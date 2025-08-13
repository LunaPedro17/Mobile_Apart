import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  static final String _baseUrl = Config.apiBaseUrl;

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<List<dynamic>> getLeaderboard() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/leaderboard'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }
}
