import '../../data/services/biometric_service.dart';
import '../repositories/i_auth_repository.dart';

/// Returns `true` when biometrics was enabled on device and server.
class EnableBiometricsUseCase {
  final IAuthRepository _authRepository;
  final BiometricService _biometricService;

  EnableBiometricsUseCase(this._authRepository, this._biometricService);

  Future<bool> call() async {
    if (!await _biometricService.isBiometricsAvailable()) {
      await _biometricService.setBiometricEnabled(false);
      return false;
    }

    await _authRepository.enrollBiometricLogin();
    return true;
  }
}
