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
    on<UploadAvatarRequested>(_onUploadAvatarRequested);
    on<ResetProfileStatus>(_onResetProfileStatus);
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
      status: ProfileStatus.loading,
      action: ProfileAction.updateProfile,
      clearError: true,
    ));

    try {
      String? avatarUrl = event.avatarUrl ?? state.user?.avatarUrl;

      // 1. Upload avatar to Cloudflare R2 if a new file is provided
      if (event.avatarFile != null) {
        avatarUrl = await uploadProfileImageUseCase(
          event.avatarFile!,
          onProgress: (sent, total) {
            if (total > 0) {
              emit(state.copyWith(uploadProgress: sent / total));
            }
          },
        );
      }

      // 2. Call PUT /users/me/profile to update mutable fields
      final updatedUser = await updateProfileUseCase(
        fullName: event.fullName,
        avatarUrl: avatarUrl,
        phone: event.phone,
      );

      emit(state.copyWith(
        status: ProfileStatus.success,
        action: ProfileAction.updateProfile,
        user: updatedUser,
        successMessage: 'Profile updated successfully',
        uploadProgress: 0.0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        action: ProfileAction.updateProfile,
        errorMessage: e.toString(),
        uploadProgress: 0.0,
      ));
    }
  }

  Future<void> _onUploadAvatarRequested(
    UploadAvatarRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: ProfileStatus.loading,
      action: ProfileAction.uploadAvatar,
      clearError: true,
    ));

    try {
      final publicUrl = await uploadProfileImageUseCase(
        event.file,
        onProgress: (sent, total) {
          if (total > 0) {
            emit(state.copyWith(uploadProgress: sent / total));
          }
        },
      );

      // Persist the new avatar URL into profile
      final updatedUser = await updateProfileUseCase(
        fullName: state.user?.fullName ?? '',
        avatarUrl: publicUrl,
        phone: state.user?.phone,
      );

      emit(state.copyWith(
        status: ProfileStatus.success,
        action: ProfileAction.uploadAvatar,
        user: updatedUser,
        successMessage: 'Avatar updated successfully',
        uploadProgress: 0.0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        action: ProfileAction.uploadAvatar,
        errorMessage: e.toString(),
        uploadProgress: 0.0,
      ));
    }
  }

  void _onResetProfileStatus(
    ResetProfileStatus event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      status: ProfileStatus.initial,
      action: ProfileAction.none,
      clearError: true,
      clearSuccess: true,
    ));
  }
}
