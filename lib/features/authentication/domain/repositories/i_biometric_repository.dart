abstract class IBiometricRepository {
  Future<bool> isBiometricsAvailable();

  Future<bool> authenticate({required String localizedReason});

  bool get isBiometricEnabled;

  Future<void> setBiometricEnabled(bool enabled);
}
