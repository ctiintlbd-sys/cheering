import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
      appBar: CustomSliverAppBar(
        toolbarHeight: 0,
        expandedHeight: kToolbarHeight,
        flexibleChild: SizedBox.shrink(),
      ),
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

        SizedBox(height: 12.h),
        CustomText(
          text:
              "Please wait a moment while we confirm your order This won't take long",
          color: context.colors.textTertiary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 28.h),
        const OrderDetailsCard(),
        SizedBox(height: 28.h),
        CustomButton(
          text: 'Looks Good',
          onPressed: () {
            context.go(RoutePaths.orderPlaced);
          },
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'Modify(00.05)',
          backgroundColor: Colors.transparent,
          textColor: context.colors.textPrimary,
          bordersColor: context.colors.borderPrimary,
          onPressed: () {},
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
