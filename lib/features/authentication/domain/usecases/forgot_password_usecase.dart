import '../repositories/i_auth_repository.dart';

class ForgotPasswordUseCase {
  final IAuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<String> call({required String email}) async {
    final message = await _repository.forgotPassword(email: email);
    return message.isEmpty
        ? 'If an account exists, a reset code has been sent'
        : message;
  }
}
