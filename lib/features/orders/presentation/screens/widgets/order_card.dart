import 'package:cheering/core/utils/app_date_formatter.dart';

import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'order_restaurant_info.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final isScheduled =
        order.scheduledFor != null &&
        order.scheduledFor!.isAfter(DateTime.now());
    return RepaintBoundary(
      child: CustomContainer(
        onTap: () => context.push(RoutePaths.details(order.id)),
        width: double.infinity,
        paddingAll: 16.w,
        radiusAll: 16,
        bordersColor: context.colors.borderSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            OrderRestaurantInfo(order: order),
            SizedBox(height: 8.w),
            Divider(color: context.colors.borderSecondary),
            SizedBox(height: 10.w),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: '৳${order.grandTotal.toStringAsFixed(2)}',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.r,
                  ),
                ),
                if (isScheduled)
                  _buildActionButton(
                    context: context,
                    text:
                        'Order In ${AppDateFormatter.formatRemainingTime(order.scheduledFor!.difference(DateTime.now()))}',
                    icon: Icons.access_time,
                  )
                else if (order.status == 'DELIVERED') ...[
                  if (order.canReview)
                    _buildActionButton(
                      context: context,
                      text: 'Rate Order',
                      onTap: () =>
                          context.push(RoutePaths.rateOrder, extra: order),
                      isPrimary: false,
                    ),
                  SizedBox(width: 8.w),
                  _buildActionButton(
                    context: context,
                    text: 'Order Again',
                    onTap: order.restaurantId.isEmpty
                        ? null
                        : () => context.push(
                            RoutePaths.storeDetails(order.restaurantId),
                          ),
                  ),
                ] else
                  _buildActionButton(
                    context: context,
                    text: 'Track Order',
                    onTap: () => context.push(RoutePaths.tracking(order.id)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    VoidCallback? onTap,
    bool isPrimary = true,
    IconData? icon,
  }) {
    return CustomContainer(
      onTap: onTap,
      radiusAll: 38.r,
      paddingHorizontal:  12.w,
      paddingVertical: 8.w,
      color: isPrimary ? context.colors.primary : null,
      bordersColor: isPrimary ? null : context.colors.borderSecondary,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isPrimary
                  ? context.colors.white
                  : context.colors.textPrimary,
              size: 16.r,
            ),
            SizedBox(width: 8.w),
          ],
          CustomText(
            fontSize:  12.r,
            fontWeight: FontWeight.w600,
            color: isPrimary ? context.colors.white : null,
            text: text,
          ),
        ],
      ),
    );
  }
}
