import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/authentication/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final profile = user;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return CustomContainer(
      onTap: () => context.push(RoutePaths.accountSettings),
      paddingVertical: 8.w,
      paddingHorizontal: 12.w,
      radiusAll: 8.r,
      color: context.colors.bgSecondary,
      child: Row(
        children: [
          CustomNetworkImage(
            boxShape: BoxShape.circle,
            height: 64.r,
            width: 64.r,
            imageUrl: profile.avatarUrl,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontSize: 16.r,
                  fontWeight: FontWeight.w600,
                  text: profile.fullName,
                ),
                CustomText(
                  top: 4.w,
                  color: context.colors.textTertiary,
                  text: profile.email,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.r,
            color: context.colors.iconTertiary,
          ),
        ],
      ),
    );
  }
}
