import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final Widget? icon;

  const EmptyState({super.key, this.message = 'No data found', this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 120.h, horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Assets.icons.emptyOrder.svg(),
            SizedBox(height: 16.h),
            CustomText(
              text: message,
              color: context.colors.textTertiary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
