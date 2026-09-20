import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(title: 'Community'),
      bodyList: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Assets.icons.communityFil.svg(
                    width: 48.r,
                    height: 48.r,
                  ),
                ),
                SizedBox(height: 24.w),
                CustomText(
                  text: 'Coming Soon!',
                  fontSize: 24.r,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
                SizedBox(height: 12.w),
                CustomText(
                  text:
                      'We are working hard to bring you a vibrant community experience. Stay tuned for exciting updates!',
                  fontSize: 14.r,
                  fontWeight: FontWeight.w400,
                  color: context.colors.textSecondary,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  textHeight: 1.5,
                ),
                SizedBox(height: 80.w),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
