/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditStoreProfileScreen extends StatefulWidget {
  const EditStoreProfileScreen({super.key});

  @override
  State<EditStoreProfileScreen> createState() => _EditStoreProfileScreenState();
}

class _EditStoreProfileScreenState extends State<EditStoreProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _descController = TextEditingController(text: profile?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSaveChanges() {
    final state = context.read<ProfileBloc>().state;
    final uploadedImageUrl = state.uploadedImageUrl;
    final profile = state.profile;
    context.read<ProfileBloc>().add(
      UpdateProfile(
        UpdateVendorProfileParams(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          description: _descController.text.trim(),
          logoUrl: uploadedImageUrl ?? profile?.logoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
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
      builder: (context, state) {
        final isSaving = state.updateProfileStatus == UpdateProfileStatus.loading;
        final isUploading = state.uploadStatus == ProfileUploadStatus.uploading;
        final currentLogoUrl = state.uploadedImageUrl ?? state.profile?.logoUrl ?? '';
        return SliverScaffold(
          appBar: const CustomSliverAppBar(title: 'Store Profile'),
          bodyList: [
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: isUploading
                    ? null
                    : () {
                        context.pickImageWithCrop(
                          cropConfig: ImageCropHelper.productPicture,
                          onCropped: (File croppedFile) {
                            context.read<ProfileBloc>().add(
                              UploadProfileImage(croppedFile),
                            );
                          },
                        );
                      },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomNetworkImage(
                      imageUrl: currentLogoUrl,
                      imageFile: null,
                      width: 70.r,
                      height: 70.r,
                      borderRadius: 16.r,
                    ),
                    CustomText(
                      top: 8.h,
                      text: isUploading
                          ? 'Uploading ${(state.uploadProgress * 100).toInt()}%'
                          : 'Change photo',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primary,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ── 2. Form Input Fields ─────────────────────────────────
            CustomTextField(
              labelText: 'Store name',
              controller: _nameController,
              hintText: 'Enter your store name',
            ).asSliverWithPadding(horizontal: 16.w),

            SizedBox(height: 12.h),

            CustomTextField(
              labelText: 'Phone number',
              controller: _phoneController,
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
            ).asSliverWithPadding(horizontal: 16.w),

            SizedBox(height: 12.h),

            CustomTextField(
              labelText: 'Description',
              controller: _descController,
              hintText: 'Enter a brief description of your store',
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ).asSliverWithPadding(horizontal: 16.w),
            SizedBox(height: 32.h),
          ],
          bottomNavigationBar: CustomButton(
            text: 'Save Changes',
            isLoading: isSaving,
            onPressed: isSaving ? null : _onSaveChanges,
          ),
        );
      },
    );
  }
}
*/
