import 'package:flutter/material.dart';
import 'package:yily_app/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool get isAuthenticated => _token != null;

  Future<void> init() async {
    _token = await StorageService().getToken();
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    await StorageService().saveToken(token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await StorageService().deleteToken();
    notifyListeners();
  }
}