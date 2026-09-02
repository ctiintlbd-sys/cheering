import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/overview/domain/entities/overview_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OverviewRecentOrderCard extends StatelessWidget {
  final OverviewRecentOrderEntity order;
  final VoidCallback? onTap;

  const OverviewRecentOrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0', 'en_US');
    final formattedPrice = '৳${currencyFormat.format(order.price.toInt())}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: CustomContainer(
          width: double.infinity,
          color: context.colors.background,
          radiusAll: 16,
          bordersColor: context.colors.borderTertiary,
          borderWidth: 1,
          paddingHorizontal: 12,
          paddingVertical: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left Info ──────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.bgSuccessPrimary,
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: CustomText(
                          text: order.status,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.bgSuccessSecondary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Order Number
                      CustomText(
                        text: order.orderNumber,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Customer Name
                  CustomText(
                    text: order.customerName,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              // ── Right Info ─────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time Ago
                  CustomText(
                    text: order.timeAgo,
                    color: context.colors.textSecondary,
                  ),
                  SizedBox(height: 16.h),
                  // Price
                  CustomText(
                    text: formattedPrice,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
