import 'package:cheering/core/utils/app_date_formatter.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/order_detail_entity.dart';
import 'package:cheering/features/orders/presentation/helpers/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsItemsCard extends StatelessWidget {
  const OrderDetailsItemsCard({super.key, required this.order});

  final OrderDetailEntity order;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = OrderStatus.badge(context, order.status);

    return CustomContainer(
      color: context.colors.background,
      radiusAll: 12.r,
      paddingAll: 12.w,
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.02),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: order.restaurantName,
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CustomText(
              top: 6.w,
              text: _orderMeta(),
              fontSize: 12.r,
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: 16.w),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, _) => SizedBox(height: 16.w),
            itemBuilder: (context, index) =>
                _itemRowWidget(context, order.items[index]),
          ),
        ],
      ),
    );
  }



  Widget _itemRowWidget(BuildContext context, OrderItemEntity item) {
    final extras = [
      if (item.variantName != null && item.variantName!.isNotEmpty)
        item.variantName!,
      ...item.addOnNames,
    ].join(' • ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNetworkImage(
          imageUrl: item.imageUrl,
          height: 66.r,
          width: 66.r,
          borderRadius: 12.r,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: item.name,
                fontWeight: FontWeight.w600,
                maxLines: 1,
              ),
              if (extras.isNotEmpty)
                CustomText(
                  top: 2.w,
                  text: extras,
                  fontSize: 12.r,
                  color: context.colors.textTertiary,
                  maxLines: 1,
                ),
              CustomText(
                top: 4.w,
                text: '৳${item.lineTotal.toStringAsFixed(0)}',
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }




  String _orderMeta() {
    final id = order.orderNumber > 0 ? '#${order.orderNumber}' : '';
    final date = _placedLabel(order.placedAt);
    if (id.isEmpty) return date;
    if (date.isEmpty) return 'Order $id';
    return 'Order $id • $date';
  }

  String _placedLabel(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final time = AppDateFormatter.formatTime(date);
    return isToday
        ? 'Today, $time'
        : '${AppDateFormatter.formatDayMonth(date)}, $time';
  }
}
