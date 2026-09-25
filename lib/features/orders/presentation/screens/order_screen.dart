import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_card.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_status_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      onRefresh: () async {},
      appBar: CustomSliverAppBar(
        toolbarHeight: 18.w,
        flexibleChild: CustomText(
          text: 'Order',
          fontSize: 18.r,
          fontWeight: FontWeight.w600,
        ),
        expandedHeight: 108.w,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(28.w),
          child: const OrderStatusTabs(),
        ),
      ),

      bodyList: [
        SizedBox(height: 16.w),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList.separated(
            itemCount: 50,
            separatorBuilder: (_, _) => SizedBox(height: 12.w),
            itemBuilder: (context, index) {
              return CustomItemAnimator(index: index, child: OrderCard());
            },
          ),
        ),

        SizedBox(height: 120.w),
      ],
    );
  }
}
