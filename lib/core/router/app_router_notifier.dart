import 'package:flutter/foundation.dart';

class AppRouterNotifier extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isAuthenticated = false;
  bool _isOnboardingSeen = false;

  bool get isInitialized => _isInitialized;

  bool get isAuthenticated => _isAuthenticated;

  bool get isOnboardingSeen => _isOnboardingSeen;

  bool _pendingBiometricOffer = false;

  bool get pendingBiometricOffer => _pendingBiometricOffer;

  void setPendingBiometricOffer(bool value) {
    if (_pendingBiometricOffer == value) return;
    _pendingBiometricOffer = value;
    notifyListeners();
  }

  void clearPendingBiometricOffer() => setPendingBiometricOffer(false);

  void consumePendingBiometricOffer() {
    _pendingBiometricOffer = false;
  }

  void updateAuth({required bool isAuthenticated, bool? isOnboardingSeen}) {
    _isInitialized = true;
    _isAuthenticated = isAuthenticated;
    if (!isAuthenticated) {
      _pendingBiometricOffer = false;
    }
    if (isOnboardingSeen != null) {
      _isOnboardingSeen = isOnboardingSeen;
    }
    notifyListeners();
  }

  void completeOnboarding() {
    _isOnboardingSeen = true;
    notifyListeners();
  }
}
