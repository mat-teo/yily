import 'package:flutter/material.dart';
import 'package:yily_app/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final token = await StorageService().getToken();
    _isAuthenticated = token != null && token.isNotEmpty;

    _isLoading = false;

    notifyListeners();
  }

  Future<void> login(String accessToken) async {
    await StorageService().saveToken(accessToken);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await StorageService().deleteToken();
    _isAuthenticated = false;
    notifyListeners();
  }
}