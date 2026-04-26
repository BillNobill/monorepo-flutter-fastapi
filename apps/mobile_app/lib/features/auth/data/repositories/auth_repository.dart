import 'package:dio/dio.dart';
import 'package:mobile_app/core/network/api_client.dart';

class AuthRepository {
  Future<String> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {
          'username': email,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return response.data['access_token'] as String;
    } catch (e) {
      rethrow;
    }
  }
}
