import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/storage/biometric_device_storage.dart';
import '../../../../core/storage/biometric_storage.dart';
import '../../domain/entities/biometric_ui_kind.dart';

class BiometricService {
  BiometricService({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  BiometricUiKind _uiKind = BiometricUiKind.combined;

  BiometricUiKind get biometricUiKind => _uiKind;

  bool get isDeviceEnrolled => BiometricDeviceStorage.hasEnrollment;

  bool get canUseBiometricLogin => isBiometricEnabled && isDeviceEnrolled;

  /// Call once at app startup so UI can read [biometricUiKind] synchronously.
  Future<void> loadUiKind() async {
    _uiKind = resolveUiKind(await getAvailableBiometrics());
  }

  static BiometricUiKind resolveUiKind(List<BiometricType> types) {
    if (types.isEmpty) return BiometricUiKind.combined;

    // Android normally reports `strong`/`weak` instead of the concrete sensor,
    // so only a face-only device gets the Face ID wording.
    final isFaceOnly =
        types.contains(BiometricType.face) &&
        !types.contains(BiometricType.fingerprint);

    return isFaceOnly ? BiometricUiKind.face : BiometricUiKind.touch;
  }

  /// Check if hardware supports biometrics
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  /// Check if biometrics can be checked (enrolled on device)
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  /// Check if biometrics is available and enrolled
  Future<bool> isBiometricsAvailable() async {
    final checks = await Future.wait([
      isDeviceSupported(),
      canCheckBiometrics(),
    ]);
    return checks.every((passed) => passed);
  }

  /// Get available biometric types (e.g. fingerprint, face)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return const [];
    }
  }

  /// Trigger native Touch ID / Face ID prompt
  Future<bool> authenticate({
    String localizedReason =
        'Please authenticate to log in to your Cheering account',
  }) async {
    try {
      if (!await isBiometricsAvailable()) return false;

      return await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    }
  }

  /// Check if user has enabled biometrics in app settings
  bool get isBiometricEnabled => BiometricStorage.isBiometricEnabled;

  /// Save user's preference to enable or disable biometrics
  Future<void> setBiometricEnabled(bool enabled) async {
    await BiometricStorage.setBiometricEnabled(enabled);
  }
}
