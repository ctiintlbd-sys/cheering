import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderStatusTabs extends StatelessWidget {
  const OrderStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final isSelected = index == 0;

          return GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.background,
                borderRadius: BorderRadius.circular(44.r),
                border: isSelected
                    ? null
                    : Border.all(
                        color: context.colors.borderTertiary,
                        width: 1,
                      ),
              ),
              child: Center(
                child: CustomText(
                  text: 'All',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  color: isSelected
                      ? context.colors.white
                      : context.colors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
