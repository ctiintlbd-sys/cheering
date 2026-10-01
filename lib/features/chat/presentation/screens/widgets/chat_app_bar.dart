import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/utils/assets/assets.gen.dart';
import '../../../../../core/widgets/widgets.dart';

class ChatAppBar extends StatelessWidget {
  final TrackingRiderEntity? rider;

  const ChatAppBar({
    super.key,
     this.rider,
  });

  Future<void> _makeCall() async {
    final cleanPhone = rider?.phone?.trim() ?? '';
    if (cleanPhone.isNotEmpty) {
      final uri = Uri(scheme: 'tel', path: cleanPhone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    }
    ToastMessageHelper.show('Cellular call is not available');
  }

  @override
  Widget build(BuildContext context) {
    return CustomSliverAppBar(
      backgroundColor: context.colors.background.withValues(alpha: 0.9),
      toolbarHeight: 64.w,
      titleWidget: Row(
        children: [
          CustomNetworkImage(
            width: 44.r,
            height: 44.r,
            boxShape: BoxShape.circle,
            imageUrl: rider?.photoUrl,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: rider?.name ?? 'Rider',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                  maxLines: 1,
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.r,
                      color: context.colors.ratingColor,
                    ),
                    SizedBox(width: 3.w),
                    CustomText(
                      text: rider?.ratingAvg?.toStringAsFixed(1) ?? '4.9',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textSecondary,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: CustomText(
                        text: '•',
                        fontSize: 12.sp,
                        color: context.colors.textTertiary,
                      ),
                    ),
                    CustomText(
                        text: rider != null && rider!.id.length >= 6
                            ? 'ID ${rider!.id.substring(rider!.id.length - 6).toUpperCase()}'
                            : 'RIDER',
                      fontSize: 12.sp,
                      color: context.colors.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          CommonActionIcon(
            onTap: _makeCall,
            icon: Assets.icons.call.path,
          ),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }
}
