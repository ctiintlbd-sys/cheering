import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, success, failure }

enum ProfileAction {
  none,
  loadProfile,
  updateProfile,
  uploadAvatar,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileAction action;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;
  final double uploadProgress;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.action = ProfileAction.none,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.uploadProgress = 0.0,
  });

  bool get isLoading => status == ProfileStatus.loading;

  bool get isLoadProfileLoading =>
      isLoading && action == ProfileAction.loadProfile;

  bool get isUpdateProfileLoading =>
      isLoading && action == ProfileAction.updateProfile;

  bool get isUploadAvatarLoading =>
      isLoading && action == ProfileAction.uploadAvatar;

  bool get hasUser => user != null;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileAction? action,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    double? uploadProgress,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      action: action ?? this.action,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        action,
        user,
        errorMessage,
        successMessage,
        uploadProgress,
      ];
}
