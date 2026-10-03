import 'package:cheering/core/utils/app_date_formatter.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:cheering/features/orders/presentation/helpers/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderRestaurantInfo extends StatelessWidget {
  const OrderRestaurantInfo({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final isScheduled =
        order.scheduledFor != null &&
        order.scheduledFor!.isAfter(DateTime.now());
    return Row(
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
                    child: isScheduled
                        ? _buildScheduledSubtitle(context)
                        : _buildNormalSubtitle(context),
                  ),
                  if (!isScheduled) _buildStatusBadge(context),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledSubtitle(BuildContext context) {
    final itemLabel = order.itemCount == 1 ? 'Item' : 'Items';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.w),
        CustomText(
          text: '${order.itemCount} $itemLabel • ${order.paymentMethod}',
          fontSize: 14.r,
          color: context.colors.textTertiary,
          maxLines: 1,
        ),
        SizedBox(height: 6.w),
        CustomContainer(
          paddingHorizontal: 10.w,
          paddingVertical: 4.w,
          color: context.colors.scheduledBg,
          radiusAll: 36.r,
          child: CustomText(
            text:
                'Scheduled at ${AppDateFormatter.formatTime(order.scheduledFor!)}',
            fontSize: 12.r,
            fontWeight: FontWeight.w500,
            color: context.colors.scheduledPrimary,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildNormalSubtitle(BuildContext context) {
    final itemLabel = order.itemCount == 1 ? 'Item' : 'Items';
    final date = order.placedAt != null
        ? '${AppDateFormatter.formatDayMonth(order.placedAt!)}, ${AppDateFormatter.formatTime(order.placedAt!)}'
        : '';
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          height: 1.88,
          fontSize: 14.r,
          color: context.colors.textTertiary,
        ),
        children: [
          TextSpan(text: '${order.itemCount} $itemLabel • '),
          TextSpan(text: '${order.paymentMethod}\n'),
          TextSpan(text: date),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final (statusLabel, statusColor) = OrderStatus.badge(context, order.status);
    return CustomContainer(
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
    );
  }
}
