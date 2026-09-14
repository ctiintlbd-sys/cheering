import '../entities/login_result_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginWithGoogleUseCase {
  final IAuthRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<LoginResultEntity> call() => _repository.loginWithGoogle();
}
