import '../repositories/i_auth_repository.dart';

class ClearLocalSessionUseCase {
  final IAuthRepository _repository;

  ClearLocalSessionUseCase(this._repository);

  Future<void> call() => _repository.clearLocalSession();
}
