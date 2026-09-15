import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadProfileImageUseCase,
  }) : super(const ProfileState()) {
    on<LoadProfileRequested>(_onLoadProfileRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<UpdateUploadProgress>(_onUpdateUploadProgress);
    on<ResetUpdateProfileStatus>(_onResetUpdateProfileStatus);
    on<ResetUploadProfileStatus>(_onResetUploadProfileStatus);
  }

  Future<void> _onLoadProfileRequested(
    LoadProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: ProfileStatus.loading,
      action: ProfileAction.loadProfile,
      clearError: true,
    ));

    try {
      final user = await getProfileUseCase();
      emit(state.copyWith(
        status: ProfileStatus.success,
        action: ProfileAction.loadProfile,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        action: ProfileAction.loadProfile,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      updateProfileStatus: UpdateProfileStatus.loading,
      clearError: true,
    ));

    try {
      final updatedUser = await updateProfileUseCase(
        fullName: event.fullName,
        avatarUrl: event.avatarUrl,
        phone: event.phone,
      );

      emit(state.copyWith(
        updateProfileStatus: UpdateProfileStatus.success,
        user: updatedUser,
      ));
    } catch (e) {
      emit(state.copyWith(
        updateProfileStatus: UpdateProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      uploadStatus: ProfileUploadStatus.uploading,
      uploadProgress: 0.0,
      clearError: true,
    ));

    try {
      final publicUrl = await uploadProfileImageUseCase(
        event.file,
        onProgress: (sent, total) {
          if (total > 0) {
            add(UpdateUploadProgress(sent / total));
          }
        },
      );

      emit(state.copyWith(
        uploadStatus: ProfileUploadStatus.success,
        uploadedImageUrl: publicUrl,
      ));
    } catch (e) {
      emit(state.copyWith(
        uploadStatus: ProfileUploadStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateUploadProgress(
    UpdateUploadProgress event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(uploadProgress: event.progress));
  }

  void _onResetUpdateProfileStatus(
    ResetUpdateProfileStatus event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(updateProfileStatus: UpdateProfileStatus.initial));
  }

  void _onResetUploadProfileStatus(
    ResetUploadProfileStatus event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(uploadStatus: ProfileUploadStatus.initial));
  }
}
