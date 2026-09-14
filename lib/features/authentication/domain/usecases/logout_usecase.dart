import '../repositories/i_auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call({bool allDevices = false}) {
    return _repository.logout(allDevices: allDevices);
  }
}
