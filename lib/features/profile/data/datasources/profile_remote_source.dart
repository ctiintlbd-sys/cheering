import 'dart:io';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/presigned_upload_model.dart';
import '../models/profile_model.dart';
import '../models/update_profile_request_model.dart';

class ProfileRemoteSource {
  final IApiClient _client;

  ProfileRemoteSource(this._client);

  /// Calls GET /users/me to fetch the authenticated user profile.
  Future<ApiResult<ProfileModel>> getProfile() {
    return _client.get(
      ApiEndpoints.currentUser,
      fromJson: (json) {
        final map = json is Map<String, dynamic> ? json : <String, dynamic>{};
        final data = map['data'] is Map<String, dynamic>
            ? map['data'] as Map<String, dynamic>
            : map;
        return ProfileModel.fromJson(data);
      },
    );
  }

  /// Calls PUT /users/me/profile to update mutable profile fields.
  Future<ApiResult<ProfileModel>> updateProfile(UpdateProfileRequestModel request) {
    return _client.put(
      ApiEndpoints.profile,
      body: request.toJson(),
      fromJson: (json) {
        final map = json is Map<String, dynamic> ? json : <String, dynamic>{};
        final data = map['data'] is Map<String, dynamic>
            ? map['data'] as Map<String, dynamic>
            : map;
        return ProfileModel.fromJson(data);
      },
    );
  }

  /// Requests a presigned R2 upload URL for avatar/media upload (POST /uploads/presigned-url).
  Future<ApiResult<PresignedUploadModel>> getPresignedUploadUrl({
    required String fileName,
    required String fileType,
  }) {
    return _client.post<PresignedUploadModel>(
      ApiEndpoints.presignedUpload,
      body: {
        'file_type': fileType,
        'file_name': fileName,
      },
      fromJson: (json) =>
          PresignedUploadModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Uploads raw image bytes directly to Cloudflare R2 using the presigned URL.
  Future<ApiResult<void>> uploadToR2({
    required String url,
    required File file,
    required String contentType,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final len = await file.length();
    return _client.putBinary(
      url,
      stream: file.openRead(),
      length: len,
      contentType: contentType,
      onSendProgress: onSendProgress,
    );
  }
}

