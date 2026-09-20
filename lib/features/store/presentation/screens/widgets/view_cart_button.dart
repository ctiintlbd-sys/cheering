import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewCartButton extends StatelessWidget {
  final int itemCount;
  final double totalPrice;
  final VoidCallback onTap;

  const ViewCartButton({
    super.key,
    required this.itemCount,
    required this.totalPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: onTap,
        child: CustomContainer(
          width: double.infinity,
          radiusAll: 99.r,
          color: context.colors.primary,
          paddingHorizontal: 20.w,
          paddingVertical: 14.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: '$itemCount item${itemCount > 1 ? 's' : ''}',
                color: context.colors.white,
                fontSize: 16.r,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: 'View cart · ৳${totalPrice.toInt()}',
                color: context.colors.white,
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
