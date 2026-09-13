import '../entities/auth_tokens_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginWithGoogleUseCase {
  final IAuthRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<AuthTokensEntity> call() {
    return _repository.loginWithGoogle();
  }
}
