import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/i_profile_repository.dart';

class UpdateProfileUseCase {
  final IProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UserEntity> call({
    required String fullName,
    String? avatarUrl,
    String? phone,
  }) {
    return _repository.updateProfile(
      fullName: fullName,
      avatarUrl: avatarUrl,
      phone: phone,
    );
  }
}
