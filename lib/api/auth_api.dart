import 'api_client.dart';

class AuthApi {
  final ApiClient client;
  AuthApi(this.client);

  Future<void> login(String usernameOrEmail, String password) async {
    final res = await client.post('/auth/login', data: {
      "username_or_email": usernameOrEmail,
      "password": password,
    });
    final token = (res.data as dynamic)['access_token'] as String;
    await client.setToken(token);
  }

  Future<void> register({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
    required String role, // "STUDENT" or "COMPANY"
  }) async {
    final res = await client.post('/auth/register', data: {
      "name": name,
      "surname": surname,
      "username": username,
      "email": email,
      "password": password,
      "role": role,
    });
    final token = (res.data as dynamic)['access_token'] as String;
    await client.setToken(token);
  }
}
