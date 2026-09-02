import 'package:flutter/foundation.dart';

class AppRouterNotifier extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isAuthenticated = false;

  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _isAuthenticated;

  void updateAuth({
    required bool isAuthenticated,
  }) {
    _isInitialized = true;
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }
}