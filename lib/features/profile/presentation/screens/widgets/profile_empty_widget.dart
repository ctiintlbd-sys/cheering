import 'package:cheering/core/router/auth_redirect.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/assets/assets.gen.dart';
import '../../../../../core/widgets/widgets.dart';

class ProfileEmptyWidget extends StatelessWidget {
  const ProfileEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.images.profileEmpty.image(width: 190.w, height: 176.w),
        CustomText(
          top: 14.w,
          textAlign: TextAlign.center,
          text: 'Welcome to Cheering Shop',
          fontSize: 24.r,
          fontWeight: FontWeight.w500,
        ),
        CustomText(
          top: 12.w,
          textAlign: TextAlign.center,
          text:
              'Sign in to access your order, settings, reward, and exclusive benefits',
          color: context.colors.textTertiary,
          bottom: 24.w,
        ),
        CustomButton(
          onPressed: () {
            context.go(AuthRedirect.loginPath(returnTo: RoutePaths.profileTab));
          },
          label: 'Login/ Sign up',
        ),
      ],
    );
  }
}
