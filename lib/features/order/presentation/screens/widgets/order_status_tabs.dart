import 'package:cheering/core/common_widgets/custom_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderStatusTabs extends StatelessWidget {
  const OrderStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final isSelected = index == 0;

          return CustomFilterChip(
            label: 'All',
            isSelected: isSelected,
            onTap: () {},
          );
        },
      ),
    );
  }
}
