import 'dart:io';

import 'package:cheering/core/helpers/picker_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cheering/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({
    super.key,
    required this.imageUrl,
    required this.isUploading,
    required this.uploadProgress,
    this.size,
  });

  final String imageUrl;
  final bool isUploading;
  final double uploadProgress;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? 94.r;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomNetworkImage.view(
              imageUrl: imageUrl,
              width: avatarSize,
              height: avatarSize,
              boxShape: BoxShape.circle,
              border: Border.all(color: context.colors.borderSecondary),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isUploading
                    ? null
                    : () {
                        context.pickImageWithCrop(
                          cropConfig: ImageCropHelper.profilePicture,
                          onCropped: (File croppedFile) {
                            context.read<ProfileBloc>().add(
                              UploadProfileImage(croppedFile),
                            );
                          },
                        );
                      },
                child: Assets.icons.imageUpdate.svg(width: 28.w, height: 28.h),
              ),
            ),
            if (isUploading)
              Positioned(
                top: 0,
                left: 0,
                child: ClipOval(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.45),
                    child: SizedBox(
                      width: avatarSize,
                      height: avatarSize,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 28.r,
                            height: 28.r,
                            child: CircularProgressIndicator(
                              value: uploadProgress > 0 ? uploadProgress : null,
                              strokeWidth: 2.5,
                              color: context.colors.background,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: '${(uploadProgress * 100).toInt()}%',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: context.colors.background,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
