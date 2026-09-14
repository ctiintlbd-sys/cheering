import '../../../../core/errors/app_exception.dart';
import '../repositories/i_biometric_repository.dart';

/// Returns `true` when biometrics was enabled, `false` when skipped because
/// hardware is unavailable (caller may still complete sign-in).
class EnableBiometricsUseCase {
  final IBiometricRepository _biometricRepository;

  EnableBiometricsUseCase(this._biometricRepository);

  Future<bool> call() async {
    if (!await _biometricRepository.isBiometricsAvailable()) {
      await _biometricRepository.setBiometricEnabled(false);
      return false;
    }

    final success = await _biometricRepository.authenticate(
      localizedReason:
          'Please authenticate to enable biometric login for Cheering',
    );

    if (!success) {
      throw const CancelledException('Biometric verification cancelled or failed.');
    }

    await _biometricRepository.setBiometricEnabled(true);
    return true;
  }
}
