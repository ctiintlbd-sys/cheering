import '../entities/reset_password_result_entity.dart';
import '../repositories/i_auth_repository.dart';

class ResetPasswordUseCase {
  final IAuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<ResetPasswordResultEntity> call({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _repository.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }
}
