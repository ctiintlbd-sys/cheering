import '../../../../core/storage/biometric_device_storage.dart';
import '../../domain/repositories/i_biometric_repository.dart';
import '../services/biometric_service.dart';

class BiometricRepositoryImpl implements IBiometricRepository {
  final BiometricService _service;

  BiometricRepositoryImpl(this._service);

  @override
  Future<bool> isBiometricsAvailable() => _service.isBiometricsAvailable();

  @override
  Future<bool> authenticate({required String localizedReason}) {
    return _service.authenticate(localizedReason: localizedReason);
  }

  @override
  bool get isBiometricEnabled => _service.isBiometricEnabled;

  @override
  bool get isDeviceEnrolled => BiometricDeviceStorage.hasEnrollment;

  @override
  bool get canUseBiometricLogin => isBiometricEnabled && isDeviceEnrolled;

  @override
  Future<void> setBiometricEnabled(bool enabled) {
    return _service.setBiometricEnabled(enabled);
  }
}
