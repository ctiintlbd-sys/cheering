import 'dart:io';

import '../../../../core/network/api_result.dart';
import '../../../../core/utils/mime_utils.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_source.dart';
import '../models/update_profile_request_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteSource _remoteSource;

  ProfileRepositoryImpl(this._remoteSource);

  @override
  Future<UserEntity> getProfile() async {
    final result = await _remoteSource.getProfile();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<UserEntity> updateProfile({
    required String fullName,
    String? avatarUrl,
    String? phone,
  }) async {
    final result = await _remoteSource.updateProfile(
      UpdateProfileRequestModel(
        fullName: fullName,
        avatarUrl: avatarUrl,
        phone: phone,
      ),
    );
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<String> uploadImage(
    File file, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final fileName = file.path.split('/').last;
    final mediaType = getMediaTypeForFile(file.path);
    final contentType = mediaType != null
        ? '${mediaType.type}/${mediaType.subtype}'
        : 'image/jpeg';

    final presignResult = await _remoteSource.getPresignedUploadUrl(
      fileName: fileName,
      fileType: contentType,
    );
    final model = presignResult.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );

    final effectiveContentType = model.contentType.isNotEmpty
        ? model.contentType
        : contentType;

    final putResult = await _remoteSource.uploadToR2(
      url: model.presignedUrl,
      file: file,
      contentType: effectiveContentType,
      onSendProgress: onProgress,
    );
    putResult.fold(onSuccess: (_) {}, onFailure: (e) => throw e);

    return model.publicUrl;
  }
}

