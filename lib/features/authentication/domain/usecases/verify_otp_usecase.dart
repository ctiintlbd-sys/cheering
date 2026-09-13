import '../entities/login_result_entity.dart';
import '../repositories/i_auth_repository.dart';

class VerifyOtpUseCase {
  final IAuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<LoginResultEntity> call({
    required String email,
    required String code,
    required String password,
    required String fullName,
  }) {
    return _repository.verifyOtp(
      email: email,
      code: code,
      password: password,
      fullName: fullName,
    );
  }
}
