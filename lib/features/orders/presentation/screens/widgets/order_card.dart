import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/app_date_formatter.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:cheering/features/orders/presentation/helpers/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final itemLabel = order.itemCount == 1 ? 'Item' : 'Items';
    final date = order.placedAt != null
        ? '${AppDateFormatter.formatDayMonth(order.placedAt!)}, ${AppDateFormatter.formatTime(order.placedAt!)}'
        : '';
    final (statusLabel, statusColor) = OrderStatus.badge(context, order.status);

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                  imageUrl: order.restaurantLogoUrl,
                  height: 72.r,
                  width: 72.r,
                  borderRadius: 12.r,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: order.restaurantName,
                        fontSize: 16.r,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  height: 1.88,
                                  fontSize: 14.r,
                                  color: context.colors.textTertiary,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${order.itemCount} $itemLabel • ',
                                  ),
                                  TextSpan(text: '${order.paymentMethod}\n'),
                                  TextSpan(text: date),
                                ],
                              ),
                            ),
                          ),
                          CustomContainer(
                            paddingHorizontal: 12.w,
                            paddingVertical: 4.w,
                            color: statusColor.withValues(alpha: 0.1),
                            radiusAll: 36.r,
                            child: CustomText(
                              text: statusLabel,
                              fontSize: 12.r,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.w),
            Divider(color: context.colors.borderSecondary),
            SizedBox(height: 10.w),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: '৳${order.grandTotal.toStringAsFixed(0)}',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (order.status == 'DELIVERED') ...[
                  CustomContainer(
                    onTap: () => context.push(
                      RoutePaths.rateOrder,
                      extra: order,
                    ),
                    radiusAll: 38.r,
                    paddingHorizontal: 12.w,
                    paddingVertical: 8.w,
                    bordersColor: context.colors.borderSecondary,
                    child: CustomText(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w600,
                      text: 'Rate Order',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CustomContainer(
                    onTap: order.restaurantId.isEmpty
                        ? null
                        : () => context.push(
                      RoutePaths.storeDetails(order.restaurantId),
                    ),
                    radiusAll: 38.r,
                    paddingHorizontal: 12.w,
                    paddingVertical: 8.w,
                    color: context.colors.primary,
                    child: CustomText(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w600,
                      color: context.colors.white,
                      text: 'Order Again',
                    ),
                  ),
                ]else
                  CustomContainer(
                    onTap:  () => context.push(RoutePaths.tracking(order.id)),
                    radiusAll: 38.r,
                    paddingHorizontal: 12.w,
                    paddingVertical: 8.w,
                    color: context.colors.primary,
                    child: CustomText(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w600,
                      color: context.colors.white,
                      text: 'Track Order',
                    ),
                  ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
