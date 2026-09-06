import 'package:cheering/features/community/domain/entities/community_post.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityStoryBar extends StatelessWidget {
  final List<StoryItem> stories;

  const CommunityStoryBar({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 98.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: stories.length,
        separatorBuilder: (_, _) => SizedBox(width: 14.w),
        itemBuilder: (context, index) {
          final item = stories[index];
          return _buildStoryItem(context, item);
        },
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, StoryItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            // Avatar with Gradient Ring
            Container(
              padding: EdgeInsets.all(2.5.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: item.isUserStory
                      ? [context.colors.primary, context.colors.secondary]
                      : [const Color(0xFFFF2A7A), const Color(0xFFFF7B00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  shape: BoxShape.circle,
                ),
                child: CustomNetworkImage(
                  imageUrl: item.avatarUrl,
                  height: 60.r,
                  width: 60.r,
                  boxShape: BoxShape.circle,
                ),
              ),
            ),

            // Plus icon for User Story
            if (item.isUserStory)
              Positioned(
                right: 2.w,
                bottom: 2.h,
                child: CustomContainer(
                  shape: BoxShape.circle,
                  color: context.colors.primary,
                  paddingAll: 3.r,
                  bordersColor: context.colors.white,
                  child: Icon(
                    Icons.add,
                    size: 14.r,
                    color: context.colors.white,
                  ),
                ),
              ),

            // Green online indicator
            if (item.isOnline && !item.isUserStory)
              Positioned(
                right: 4.w,
                bottom: 4.h,
                child: Container(
                  height: 12.r,
                  width: 12.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colors.white,
                      width: 2.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 70.w,
          child: CustomText(
            text: item.name,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: context.colors.textPrimary,
            textAlign: TextAlign.center,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
