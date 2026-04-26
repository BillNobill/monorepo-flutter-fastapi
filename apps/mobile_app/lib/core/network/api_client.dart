import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    // Lógica para detectar o host correto
    // Web/Desktop -> localhost
    // Emulador Android -> 10.0.2.2
    String host = 'localhost';
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      host = '10.0.2.2';
    }

    dio = Dio(
      BaseOptions(
        baseUrl: 'http://$host:8000/api/v1',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );
  }
}

final apiClient = ApiClient();
