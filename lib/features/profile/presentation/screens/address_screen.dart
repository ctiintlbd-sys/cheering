import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(66.h),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),
            child: CustomTextField(
              borderRadius: 99,
              fillColor: context.colors.bgSecondary,
              hintText: 'Search your area ...',
              prefixIcon: Assets.icons.search.svg(),
            ),
          ),
        ),
        title: 'My Address',
      ),
      bodyList: [
        SizedBox(height: 24.h),
        // Action Buttons Row
        Row(
          children: [
            Expanded(
              child: CustomContainer(
                color: context.colors.background,
                radiusAll: 12.r,
                bordersColor: context.colors.bgTertiary,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.black.withValues(alpha: 0.04),
                    blurRadius: 6
                  )
                ],
                paddingAll: 12.r,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.my_location,
                      color: const Color(0xFF1E65FF),
                      size: 24.r,
                    ),
                    SizedBox(height: 12.h),
                    CustomText(
                      text: 'Use current location',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomContainer(
                color: context.colors.background,
                radiusAll: 12.r,
                bordersColor: context.colors.bgTertiary,
                boxShadow: [
                  BoxShadow(
                      color: context.colors.black.withValues(alpha: 0.04),
                      blurRadius: 6
                  )
                ],
                paddingAll: 12.r,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.my_location,
                      color: const Color(0xFF1E65FF),
                      size: 24.r,
                    ),
                    SizedBox(height: 12.h),
                    CustomText(
                      text: 'Enter Manually',
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        SizedBox(height: 48.h),
        // Empty State
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.emptyLocation.svg(),
              SizedBox(height: 44.h),
              CustomText(
                textAlign: TextAlign.center,
                text: 'No saved address',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),
              CustomText(
                text:
                    'Add your delivery address\nfor a faster checkout experience',
                fontSize: 16.sp,
                color: context.colors.textTertiary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 104.h),
      ],
    );
  }
}
