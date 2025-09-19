import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, dynamic>> signUp(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse(
      'http://localhost:5000/api/auth/signup',
    ); // Change to your backend URL if needed
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Success
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Sign up failed');
    }
  }
}
