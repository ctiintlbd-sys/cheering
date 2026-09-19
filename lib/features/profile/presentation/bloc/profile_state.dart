import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, success, failure }

enum ProfileAction { none, loadProfile }

enum UpdateProfileStatus { initial, loading, success, failure }

enum ProfileUploadStatus { initial, uploading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileAction action;
  final UpdateProfileStatus updateProfileStatus;
  final ProfileUploadStatus uploadStatus;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;
  final String? uploadedImageUrl;
  final double uploadProgress;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.action = ProfileAction.none,
    this.updateProfileStatus = UpdateProfileStatus.initial,
    this.uploadStatus = ProfileUploadStatus.initial,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.uploadedImageUrl,
    this.uploadProgress = 0.0,
  });

  bool get isLoadProfileLoading =>
      status == ProfileStatus.loading && action == ProfileAction.loadProfile;

  bool get isUpdateProfileLoading =>
      updateProfileStatus == UpdateProfileStatus.loading;

  bool get hasUser => user != null;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileAction? action,
    UpdateProfileStatus? updateProfileStatus,
    ProfileUploadStatus? uploadStatus,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    String? uploadedImageUrl,
    double? uploadProgress,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearImage = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      action: action ?? this.action,
      updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      uploadedImageUrl: clearImage
          ? null
          : (uploadedImageUrl ?? this.uploadedImageUrl),
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props => [
    status,
    action,
    updateProfileStatus,
    uploadStatus,
    user,
    errorMessage,
    successMessage,
    uploadedImageUrl,
    uploadProgress,
  ];
}
