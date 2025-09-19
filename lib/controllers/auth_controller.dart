import 'package:fitgen/api/backend_api.dart';

class AuthController {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    return await BackendApi.login(email, password);
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    return await BackendApi.register(
      username: username,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
