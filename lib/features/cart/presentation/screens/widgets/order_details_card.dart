import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colors.background,
      radiusAll: 16,
      bordersColor: context.colors.borderTertiary,
      paddingHorizontal: 14.w,
      paddingVertical: 12.w,
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.02),
          offset: const Offset(0, 1),
          blurRadius: 2,
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Assets.icons.orderLocataion.svg(),
              SizedBox(width: 12.w),
              CustomText(
                text: 'KFC - Badda',
                fontSize: 14.r,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 9.w, top: 4.h, bottom: 4.h),
            child: Container(
              height: 20.h,
              width: 1,
              color: context.colors.outline,
            ),
          ),
          Row(
            children: [
              Assets.icons.orderLocataion.svg(),
              SizedBox(width: 12.w),
              CustomText(
                text: 'House 25, Banani Rd 11, Dhaka-1230',
                fontSize: 14.r,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          Divider(height: 32.h, color: context.colors.outline),
          Row(
            children: [
              CustomText(
                text: '8x',
                fontSize: 14.r,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(width: 16.w),
              CustomText(
                text: 'Fried Chicken Bucket',
                fontSize: 14.r,
                fontWeight: FontWeight.w500,
                color: context.colors.textSecondary,
              ),
            ],
          ),
          Divider(height: 32.h, color: context.colors.outline),
          Row(
            children: [
              Icon(Icons.money, size: 20.r, color: Colors.green),
              SizedBox(width: 12.w),
              CustomText(
                text: 'Cash on delivery',
                fontSize: 14.r,
                fontWeight: FontWeight.w500,
                color: context.colors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
