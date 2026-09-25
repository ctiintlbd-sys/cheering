import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      backgroundColor: context.colors.white,
      appBar: CustomSliverAppBar(
        backgroundColor: context.colors.white,
      ),
      bodyList: [
        SizedBox(height: 20.h),
        Assets.icons.orderPlaced.svg(),
        SizedBox(height: 32.h),
        CustomText(
          text: 'Order placed!',
          fontSize: 24.r,
          fontWeight: FontWeight.w700,
          color: context.colors.textPrimary,
        ),
        SizedBox(height: 12.h),
        CustomText(
          text:
              'KFC - Badda is preparing your order.\nEstimated delivery in ~ 25-35 mins.',
          fontSize: 14.r,
          color: context.colors.textSecondary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        CustomContainer(
          radiusAll: 12,
          color: context.colors.bgSecondary,
          paddingHorizontal: 16,
          paddingVertical: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Order ID',
                fontSize: 14.r,
                color: context.colors.textSecondary,
              ),
              CustomText(
                text: '#FD-58213',
                fontSize: 16.r,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ],
          ),
        ),
        const Spacer(),
        CustomButton(
          text: 'Track order',
          backgroundColor: context.colors.primary,
          textColor: context.colors.white,
          onPressed: () {},
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'Back to home',
          backgroundColor: Colors.transparent,
          textColor: context.colors.textPrimary,
          bordersColor: context.colors.outline,
          onPressed: () {
            context.go(RoutePaths.foodTab);
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
