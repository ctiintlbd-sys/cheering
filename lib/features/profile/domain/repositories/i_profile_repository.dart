import 'dart:io';

import '../../../authentication/domain/entities/user_entity.dart';

abstract class IProfileRepository {
  /// Fetches the currently authenticated user's profile (/users/me).
  Stream<UserEntity> getProfile();

  /// Updates the mutable profile fields (/users/me/profile).
  ///
  /// Note: Omitting or passing null for optional fields clears them on the server.
  /// Throws [ConflictException] (409) if the phone number already belongs to another account.
  Future<UserEntity> updateProfile({
    required String fullName,
    String? avatarUrl,
    String? phone,
  });

  /// Uploads an image file straight to Cloudflare R2 using a presigned URL.
  /// Returns the public URL of the uploaded image.
  Future<String> uploadImage(
    File file, {
    void Function(int sent, int total)? onProgress,
  });
}
