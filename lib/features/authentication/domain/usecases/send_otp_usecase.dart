import '../repositories/i_auth_repository.dart';

class SendOtpUseCase {
  final IAuthRepository _repository;

  SendOtpUseCase(this._repository);

  Future<String> call({required String email, String role = 'CUSTOMER'}) {
    return _repository.sendOtp(email: email, role: role);
  }
}
