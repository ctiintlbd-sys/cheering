import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'widgets/profile_avatar_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileBloc>().state.user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSaveChanges() {
    final blocState = context.read<ProfileBloc>().state;
    final user = blocState.user;
    context.read<ProfileBloc>().add(
      UpdateProfileRequested(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        avatarUrl: blocState.uploadedImageUrl ?? user?.avatarUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (prev, current) =>
          prev.updateProfileStatus != current.updateProfileStatus ||
          prev.uploadStatus != current.uploadStatus,
      listener: (context, state) {
        switch (state.updateProfileStatus) {
          case UpdateProfileStatus.success:
            context.read<ProfileBloc>().add(const ResetUpdateProfileStatus());
            context.read<ProfileBloc>().add(const ResetUploadProfileStatus());
            context.pop();
            break;
          case UpdateProfileStatus.failure:
            ToastMessageHelper.show(
              state.errorMessage ?? 'Failed to update profile',
            );
            context.read<ProfileBloc>().add(const ResetUpdateProfileStatus());
            break;
          case UpdateProfileStatus.initial:
          case UpdateProfileStatus.loading:
            break;
        }

        switch (state.uploadStatus) {
          case ProfileUploadStatus.failure:
            ToastMessageHelper.show(
              state.errorMessage ?? 'Failed to upload image',
            );
            context.read<ProfileBloc>().add(const ResetUploadProfileStatus());
            break;
          case ProfileUploadStatus.success:
          case ProfileUploadStatus.initial:
          case ProfileUploadStatus.uploading:
            break;
        }
      },
      child: SliverScaffold(
        sideContentPadding: 16.w,
        appBar: const CustomSliverAppBar(title: 'Account Settings'),
        bodyList: [
          SizedBox(height: 16.w),
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (prev, curr) =>
                prev.uploadStatus != curr.uploadStatus ||
                prev.uploadProgress != curr.uploadProgress ||
                prev.uploadedImageUrl != curr.uploadedImageUrl ||
                prev.user?.avatarUrl != curr.user?.avatarUrl,
            builder: (context, state) {
              final user = state.user;
              final isUploading =
                  state.uploadStatus == ProfileUploadStatus.uploading;
              final currentAvatarUrl =
                  state.uploadedImageUrl ?? user?.avatarUrl ?? '';

              return ProfileAvatarPicker(
                imageUrl: currentAvatarUrl,
                isUploading: isUploading,
                uploadProgress: state.uploadProgress,
              );
            },
          ),
          SizedBox(height: 24.w),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  labelText: 'Full Name',
                  controller: _nameController,
                  hintText: 'e.g. Tanvir Hridoy',
                ),
                SizedBox(height: 12.w),
                CustomTextField(
                  labelText: 'Email',
                  controller: _emailController,
                  hintText: 'example@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  enabled: false,
                ),
                SizedBox(height: 12.w),
                CustomTextField(
                  labelText: 'Phone number',
                  controller: _phoneController,
                  hintText: '01*************',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          SizedBox(height: 32.w),
        ],
        bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (prev, curr) =>
              prev.isUpdateProfileLoading != curr.isUpdateProfileLoading,
          builder: (context, state) {
            final isSaving = state.isUpdateProfileLoading;
            return CustomButton(
              text: 'Save Changes',
              isLoading: isSaving,
              onPressed: isSaving ? null : _onSaveChanges,
            );
          },
        ),
      ),
    );
  }
}
