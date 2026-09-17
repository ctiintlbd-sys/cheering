import 'package:cheering/core/widgets/custom_button.dart';
import 'package:cheering/core/widgets/custom_container.dart';
import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme_colors.dart';

class ManualAddressLocationSheet extends StatelessWidget {
  const ManualAddressLocationSheet({
    super.key,
    required this.address,
    required this.area,
    required this.onConfirm,
  });

  final String address;
  final String area;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      marginBottom: MediaQuery.paddingOf(context).bottom + 8.h,
      marginLeft: 16.w,
      marginRight: 16.w,
      color: context.colors.background,
      radiusAll: 20.r,
      paddingAll: 20.r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomContainer(
                width: 44.r,
                height: 44.r,
                color: context.colors.bgSecondary,
                radiusAll: 12.r,
                child: Icon(
                  Icons.location_on_outlined,
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: address.isEmpty ? 'Loading...' : address,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: area,
                      fontSize: 14.sp,
                      color: context.colors.textSecondary,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          CustomButton(
            onPressed: onConfirm,
            text: 'Confirm Location',
            width: double.infinity,
            height: 50.h,
          ),
        ],
      ),
    );
  }
}
