import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderEmptyState extends StatelessWidget {
  final String? message;
  
  const OrderEmptyState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.25),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.emptyOrder.svg(),
            SizedBox(height: 20.h),

            // Title: "No orders"
            CustomText(
              text: message ?? 'No orders',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            SizedBox(height: 4.h),

            // Description
            CustomText(
              text:
                  'Orders will appear here the moment a customer checks out. Keep your store open to keep receiving them.',
              fontSize: 12.sp,
              color: context.colors.textTertiary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
