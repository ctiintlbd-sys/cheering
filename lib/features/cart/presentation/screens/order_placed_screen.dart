import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderPlacedArgs {
  final String restaurantName;
  final int estimatedDeliveryMinutes;
  final String orderId;

  const OrderPlacedArgs({
    required this.restaurantName,
    required this.estimatedDeliveryMinutes,
    required this.orderId,
  });
}

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key, this.args});

  final OrderPlacedArgs? args;

  @override
  Widget build(BuildContext context) {
    final restaurantName = args?.restaurantName ?? 'Restaurant';
    final minutes = args?.estimatedDeliveryMinutes ?? 0;
    final orderId = args?.orderId ?? '—';
    final eta = minutes > 0 ? '$minutes-${minutes + 5}' : '25-35';

    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        toolbarHeight: 0,
        expandedHeight: kToolbarHeight,
        flexibleChild: SizedBox.shrink(),
      ),
      bodyList: [
        SizedBox(height: 18.w),
        Assets.icons.orderPlaced.svg(width: 300.w, height: 242.w),
        SizedBox(height: 32.w),
        CustomText(
          text: 'Order placed!',
          fontSize: 24.r,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.w),
        CustomText(
          text:
              '$restaurantName is preparing your order.\nEstimated delivery in ~ $eta mins.',
          color: context.colors.textTertiary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.w),
        CustomContainer(
          radiusAll: 12.r,
          color: context.colors.bgSecondary,
          paddingHorizontal: 12.w,
          paddingVertical: 16.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: 'Order ID', color: context.colors.textSecondary),
              CustomText(
                text: orderId,
                fontSize: 16.r,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ],
          ),
        ),
        SizedBox(height: 32.w),
        CustomButton(label: 'Track order', onPressed: () {}),
        SizedBox(height: 12.w),
        CustomButton(
          text: 'Back to home',
          backgroundColor: Colors.transparent,
          textColor: context.colors.textPrimary,
          bordersColor: context.colors.borderPrimary,
          onPressed: () => context.go(RoutePaths.foodTab),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
