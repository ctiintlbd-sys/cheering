import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/i_profile_repository.dart';

class GetProfileUseCase {
  final IProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.getProfile();
  }
}
