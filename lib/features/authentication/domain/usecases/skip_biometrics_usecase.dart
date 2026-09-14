import '../repositories/i_biometric_repository.dart';

class SkipBiometricsUseCase {
  final IBiometricRepository _biometricRepository;

  SkipBiometricsUseCase(this._biometricRepository);

  Future<void> call() => _biometricRepository.setBiometricEnabled(false);
}
