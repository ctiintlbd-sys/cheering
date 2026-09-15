import 'dart:io';

import 'package:cheering/core/config/chache_keys.dart';
import 'package:cheering/core/network/api_result.dart';

import '../../../../core/cache/cache_service.dart';
import '../../../../core/utils/mime_utils.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_source.dart';
import '../models/profile_model.dart';
import '../models/update_profile_request_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteSource _source;
  final CacheService _cache;

  ProfileRepositoryImpl(this._source, this._cache);

  @override
  Stream<UserEntity> getProfile() => _cache.getOrFetch(
        CacheKeys.profile,
        fromJson: (json) {
          final data =
              json['data'] is Map<String, dynamic> ? json['data'] : json;
          return ProfileModel.fromJson(data as Map<String, dynamic>);
        },
        toJson: (e) => (e as ProfileModel).toJson(),
        fetch: () => _source.getProfile(),
        ttl: const Duration(hours: 24),
      );

  @override
  Future<UserEntity> updateProfile({
    required String fullName,
    String? avatarUrl,
    String? phone,
  }) async {
    final result = await _source.updateProfile(
      UpdateProfileRequestModel(
        fullName: fullName,
        avatarUrl: avatarUrl,
        phone: phone,
      ),
    );
    return result.fold(
      onSuccess: (data) async {
        await _cache.set<ProfileModel>(
          CacheKeys.profile,
          data,
          toJson: (e) => e.toJson(),
          ttl: const Duration(hours: 24),
        );
        return data;
      },
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

    final presignResult = await _source.getPresignedUploadUrl(
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

    final putResult = await _source.uploadToR2(
      url: model.presignedUrl,
      file: file,
      contentType: effectiveContentType,
      onSendProgress: onProgress,
    );
    putResult.fold(onSuccess: (_) {}, onFailure: (e) => throw e);

    return model.publicUrl;
  }
}
