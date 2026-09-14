import 'dart:io';

import '../repositories/i_profile_repository.dart';

class UploadProfileImageUseCase {
  final IProfileRepository _repository;

  UploadProfileImageUseCase(this._repository);

  Future<String> call(
    File file, {
    void Function(int sent, int total)? onProgress,
  }) {
    return _repository.uploadImage(file, onProgress: onProgress);
  }
}
