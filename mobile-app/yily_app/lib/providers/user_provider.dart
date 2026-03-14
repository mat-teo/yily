import 'package:flutter/material.dart';
import 'package:yily_app/services/api_service.dart';

class UserProvider with ChangeNotifier {
  String? myName;
  String? partnerName;
  int? partnerId;
  String? coupleToken;

  bool get hasPartner => partnerName != null && partnerId != null;

  Future<void> loadUserInfo() async {
    try {
      final api = ApiService();
      final data = await api.getUserInfo(); 

      final users = data['users'] as List<dynamic>? ?? [];
      if (users.isEmpty) return;

      users.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

      myName = users[0]['name'] as String?;
      if (users.length > 1) {
        partnerName = users[1]['name'] as String?;
        partnerId = users[1]['id'] as int?;
      }
      coupleToken = data['token'] as String?;

      notifyListeners();
    } catch (e) {
      print('Errore loadUserInfo: $e');
    }
  }

  void clear() {
    myName = null;
    partnerName = null;
    partnerId = null;
    coupleToken = null;
    notifyListeners();
  }
}