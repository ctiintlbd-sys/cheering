abstract class IBiometricRepository {
  Future<bool> isBiometricsAvailable();

  Future<bool> authenticate({required String localizedReason});

  bool get isBiometricEnabled;

  bool get isDeviceEnrolled;

  bool get canUseBiometricLogin;

  Future<void> setBiometricEnabled(bool enabled);
}
