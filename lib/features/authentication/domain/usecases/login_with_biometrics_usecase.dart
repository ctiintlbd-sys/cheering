import '../../../../core/errors/app_exception.dart';
import '../repositories/i_auth_repository.dart';
import '../repositories/i_biometric_repository.dart';

class LoginWithBiometricsUseCase {
  final IAuthRepository _authRepository;
  final IBiometricRepository _biometricRepository;

  LoginWithBiometricsUseCase(this._authRepository, this._biometricRepository);

  Future<void> call() async {
    if (!await _authRepository.hasStoredSession()) {
      throw const BadRequestException(
        'Please log in with password once before using Touch ID.',
      );
    }

    if (!await _biometricRepository.isBiometricsAvailable()) {
      throw const BadRequestException(
        'Biometrics is not available or enrolled on this device.',
      );
    }

    final authenticated = await _biometricRepository.authenticate(
      localizedReason: 'Scan fingerprint to log in to Cheering',
    );

    if (!authenticated) {
      throw const CancelledException('Biometric authentication cancelled or failed.');
    }
  }
}
