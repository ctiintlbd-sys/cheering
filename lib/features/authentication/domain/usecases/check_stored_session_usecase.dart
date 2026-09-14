import '../repositories/i_auth_repository.dart';

class CheckStoredSessionUseCase {
  final IAuthRepository _repository;

  CheckStoredSessionUseCase(this._repository);

  Future<bool> call() => _repository.hasStoredSession();
}
