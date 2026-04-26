import 'package:dio/dio.dart';
import 'package:mobile_app/core/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Potentially trigger a logout here if you have access to the provider
      // For now, we just pass the error
    }
    return handler.next(err);
  }
}
