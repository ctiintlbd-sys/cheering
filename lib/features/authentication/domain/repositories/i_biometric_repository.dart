import '../entities/biometric_ui_kind.dart';

abstract class IBiometricRepository {
  BiometricUiKind get biometricUiKind;

  Future<bool> isBiometricsAvailable();

  Future<bool> authenticate({required String localizedReason});

  bool get isBiometricEnabled;

  bool get isDeviceEnrolled;

  bool get canUseBiometricLogin;

  Future<void> setBiometricEnabled(bool enabled);
}
