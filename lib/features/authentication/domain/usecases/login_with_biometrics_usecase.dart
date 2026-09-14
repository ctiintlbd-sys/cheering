import '../entities/login_result_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginWithBiometricsUseCase {
  final IAuthRepository _authRepository;

  LoginWithBiometricsUseCase(this._authRepository);

  Future<LoginResultEntity> call() => _authRepository.loginWithBiometric();
}
