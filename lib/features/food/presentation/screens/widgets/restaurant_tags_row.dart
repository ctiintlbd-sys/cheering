import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/delivery_time_sheet.dart';
import 'package:cheering/features/orders/domain/entities/order_schedule_state.dart';
import 'package:cheering/core/utils/app_date_formatter.dart';

class RestaurantTagsRow extends StatelessWidget {
  final RestaurantEntity? restaurant;

  const RestaurantTagsRow({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (restaurant?.promotions != null &&
              restaurant!.promotions!.isNotEmpty) ...[
            CustomMenuContainer(
              items: restaurant!.promotions!.map((e) => e.title).toList(),
              onSelected: (selectedPromo) {},
              child: _buildTag(
                context: context,
                icon: Icons.local_offer_outlined,
                text: restaurant!.promotions!.first.title,
                color: context.colors.primary,
                bgColor: context.colors.primary.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          ValueListenableBuilder<DateTime?>(
            valueListenable: OrderScheduleState.scheduledForNotifier,
            builder: (context, scheduledDate, _) {
              final isScheduledForThis = OrderScheduleState.restaurantId == restaurant?.id && scheduledDate != null;
              final timeText = isScheduledForThis
                  ? AppDateFormatter.formatScheduleTime(scheduledDate)
                  : 'Order for Later';
              final tagColor = isScheduledForThis ? context.colors.primary : context.colors.textPrimary;
              final tagBgColor = isScheduledForThis ? context.colors.primary.withValues(alpha: 0.1) : context.colors.bgSecondary;
              final tagIcon = isScheduledForThis ? Icons.schedule : Icons.calendar_today_outlined;
              return GestureDetector(
                onTap: () async {
                  if (restaurant?.businessHours == null || restaurant!.businessHours!.isEmpty) {
                    ToastMessageHelper.show('Business hours are not available for this restaurant.');
                    return;
                  }
                  final selectedTime = await DeliveryTimeSheet.show(context, restaurant!.businessHours!);
                  if (selectedTime != null) {
                    OrderScheduleState.setSchedule(restaurant!.id, selectedTime);
                  }
                },
                child: _buildTag(
                  context: context,
                  icon: tagIcon,
                  text: timeText,
                  color: tagColor,
                  bgColor: tagBgColor,
                  suffixIcon: isScheduledForThis
                      ? GestureDetector(
                          onTap: () {
                            OrderScheduleState.clear();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.w),
                            child: Icon(Icons.close, color: tagColor, size: 14.r),
                          ),
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ).horizontal(16.w),
    );
  }

  Widget _buildTag({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.r),
          SizedBox(width: 6.w),
          CustomText(
            text: text,
            color: color,
            fontSize: 12.r,
            fontWeight: FontWeight.w600,
          ),
          ?suffixIcon,
        ],
      ),
    );
  }
}
