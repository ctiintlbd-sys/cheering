import '../repositories/i_auth_repository.dart';
import '../repositories/i_biometric_repository.dart';

/// Returns `true` when biometrics was enabled on device and server.
class EnableBiometricsUseCase {
  final IAuthRepository _authRepository;
  final IBiometricRepository _biometricRepository;

  EnableBiometricsUseCase(this._authRepository, this._biometricRepository);

  Future<bool> call() async {
    if (!await _biometricRepository.isBiometricsAvailable()) {
      await _biometricRepository.setBiometricEnabled(false);
      return false;
    }

    await _authRepository.enrollBiometricLogin();
    return true;
  }
}
