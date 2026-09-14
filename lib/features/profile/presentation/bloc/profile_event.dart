import 'dart:io';

import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered to fetch the current authenticated user profile (GET /users/me).
class LoadProfileRequested extends ProfileEvent {
  const LoadProfileRequested();
}

/// Triggered when updating profile fields (PUT /users/me/profile).
///
/// If [avatarFile] is provided, it will first be uploaded to Cloudflare R2
/// using the presigned URL, and the resulting public URL will be set as [avatarUrl].
class UpdateProfileRequested extends ProfileEvent {
  final String fullName;
  final String? avatarUrl;
  final String? phone;
  final File? avatarFile;

  const UpdateProfileRequested({
    required this.fullName,
    this.avatarUrl,
    this.phone,
    this.avatarFile,
  });

  @override
  List<Object?> get props => [fullName, avatarUrl, phone, avatarFile];
}

/// Triggered to upload only the avatar file to Cloudflare R2 and update the profile.
class UploadAvatarRequested extends ProfileEvent {
  final File file;

  const UploadAvatarRequested(this.file);

  @override
  List<Object?> get props => [file];
}

/// Triggered to clear transient error or success status after handling in UI.
class ResetProfileStatus extends ProfileEvent {
  const ResetProfileStatus();
}
