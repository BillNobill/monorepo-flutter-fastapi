import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/storage_service.dart';
import 'package:mobile_app/features/auth/data/repositories/auth_repository.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  AuthStatus _status = AuthStatus.uninitialized;
  String? _token;

  AuthStatus get status => _status;
  String? get token => _token;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await storageService.getToken();
    _status = _token != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      _token = await _repository.login(email, password);
      await storageService.saveToken(_token!);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await storageService.deleteToken();
    _token = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
