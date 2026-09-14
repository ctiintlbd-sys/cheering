import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/storage/biometric_storage.dart';
import '../../domain/entities/biometric_ui_kind.dart';

class BiometricService {
  final LocalAuthentication _auth;

  BiometricUiKind _uiKind = BiometricUiKind.combined;

  BiometricService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  BiometricUiKind get uiKind => _uiKind;

  /// Call once at app startup so UI can read [uiKind] synchronously.
  Future<void> loadUiKind() async {
    _uiKind = resolveUiKind(await getAvailableBiometrics());
  }

  static BiometricUiKind resolveUiKind(List<BiometricType> types) {
    if (types.isEmpty) return BiometricUiKind.combined;

    final hasFace = types.contains(BiometricType.face);
    final hasFingerprint = types.contains(BiometricType.fingerprint);

    if (hasFace && !hasFingerprint) return BiometricUiKind.face;
    if (hasFingerprint && !hasFace) return BiometricUiKind.touch;
    if (hasFace && hasFingerprint) return BiometricUiKind.touch;

    return hasFace ? BiometricUiKind.face : BiometricUiKind.touch;
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
    final supported = await isDeviceSupported();
    final canCheck = await canCheckBiometrics();
    return supported && canCheck;
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
      final available = await isBiometricsAvailable();
      if (!available) return false;

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
