import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlacingOrderScreen extends StatefulWidget {
  const PlacingOrderScreen({super.key});

  @override
  State<PlacingOrderScreen> createState() => _PlacingOrderScreenState();
}

class _PlacingOrderScreenState extends State<PlacingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(),
      bodyList: [
        Assets.images.placingOrder.image(width: 284.w, height: 176.w),
        SizedBox(height: 24.h),
        CustomText(
          text: 'Placing your Order...',
          fontSize: 24.r,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: SizedBox(
            height: 10.h,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
              backgroundColor: context.colors.primary.withValues(alpha: 0.2),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        CustomText(
          text:
              "Please wait a moment while we confirm your order This won't take long",
          color: context.colors.textTertiary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        CustomContainer(
          radiusAll: 16,
          bordersColor: context.colors.borderTertiary,
          paddingHorizontal: 14.w,
          paddingVertical: 12.w,
          boxShadow: [
            BoxShadow(
              color: context.colors.black.withValues(alpha: 0.02),
              offset: Offset(0, 1),
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
        ),
        const Spacer(),
        CustomButton(
          text: 'Looks Good',
          backgroundColor: context.colors.primary,
          textColor: context.colors.white,
          onPressed: () {},
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'Modify(00.05)',
          backgroundColor: Colors.transparent,
          textColor: context.colors.textPrimary,
          bordersColor: context.colors.outline,
          onPressed: () {},
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
