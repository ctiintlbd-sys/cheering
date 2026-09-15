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

/// Clears in-memory profile after logout or forced local session clear.
class ProfileSessionCleared extends ProfileEvent {
  const ProfileSessionCleared();
}

/// Triggered when updating profile fields (PUT /users/me/profile).
class UpdateProfileRequested extends ProfileEvent {
  final String fullName;
  final String? avatarUrl;
  final String? phone;

  const UpdateProfileRequested({
    required this.fullName,
    this.avatarUrl,
    this.phone,
  });

  @override
  List<Object?> get props => [fullName, avatarUrl, phone];
}

/// Uploads a new avatar to R2; URL is stored until [UpdateProfileRequested].
class UploadProfileImage extends ProfileEvent {
  final File file;

  const UploadProfileImage(this.file);

  @override
  List<Object?> get props => [file];
}

class UpdateUploadProgress extends ProfileEvent {
  final double progress;

  const UpdateUploadProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ResetUpdateProfileStatus extends ProfileEvent {
  const ResetUpdateProfileStatus();
}

class ResetUploadProfileStatus extends ProfileEvent {
  const ResetUploadProfileStatus();
}
