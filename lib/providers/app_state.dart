
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  String? _token;
  bool _isAdmin = false;

  String? get token => _token;
  bool get isAdmin => _isAdmin;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setAdminStatus(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }
}