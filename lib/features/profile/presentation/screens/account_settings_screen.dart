import 'dart:io';

import 'package:cheering/core/helpers/picker_helper.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    final user = context.read<ProfileBloc>().state.user;
    if (user != null) {
      _nameController.text = user.fullName;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    } else {
      context.read<ProfileBloc>().add(const LoadProfileRequested());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSaveChanges() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ToastMessageHelper.show('Please enter your full name');
      return;
    }

    final phoneText = _phoneController.text.trim();

    context.read<ProfileBloc>().add(
          UpdateProfileRequested(
            fullName: name,
            phone: phoneText.isNotEmpty ? phoneText : null,
            avatarFile: _selectedImage,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success &&
            state.action == ProfileAction.updateProfile) {
          ToastMessageHelper.show(
            state.successMessage ?? 'Profile updated successfully',
          );
          context.read<ProfileBloc>().add(const ResetProfileStatus());
          Navigator.of(context).pop();
        } else if (state.status == ProfileStatus.failure) {
          ToastMessageHelper.show(
            state.errorMessage ?? 'Failed to update profile',
          );
          context.read<ProfileBloc>().add(const ResetProfileStatus());
        } else if (state.status == ProfileStatus.success &&
            state.action == ProfileAction.loadProfile) {
          final user = state.user;
          if (user != null && _nameController.text.isEmpty) {
            _nameController.text = user.fullName;
            _emailController.text = user.email;
            _phoneController.text = user.phone ?? '';
          }
        }
      },
      builder: (context, state) {
        final user = state.user;

        return SliverScaffold(
          sideContentPadding: 16.w,
          appBar: const CustomSliverAppBar(title: 'Account Settings'),
          bodyList: [
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  CustomNetworkImage.view(
                    imageUrl: user?.avatarUrl ?? '',
                    imageFile: _selectedImage,
                    width: 94.r,
                    height: 94.r,
                    boxShape: BoxShape.circle,
                    border: Border.all(color: context.colors.borderSecondary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.pickImageWithCrop(
                          cropConfig: ImageCropHelper.profilePicture,
                          onCropped: (file) {
                            setState(() {
                              _selectedImage = file;
                            });
                          },
                        );
                      },
                      child: Assets.icons.imageUpdate.svg(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // ── Form Input Fields ─────────────────────────────────
            CustomTextField(
              labelText: 'Full Name',
              controller: _nameController,
              hintText: 'e.g. Tanvir Hridoy',
            ),

            SizedBox(height: 12.h),

            CustomTextField(
              labelText: 'Email',
              controller: _emailController,
              hintText: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
              enabled: false,
            ),
            SizedBox(height: 12.h),

            CustomTextField(
              labelText: 'Phone number',
              controller: _phoneController,
              hintText: '01*************',
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 32.h),
          ],
          bottomNavigationBar: CustomButton(
            text: 'Save Changes',
            isLoading: state.isUpdateProfileLoading,
            onPressed: _onSaveChanges,
          ),
        );
      },
    );
  }
}
