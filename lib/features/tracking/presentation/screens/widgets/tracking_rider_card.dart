import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingRiderCard extends StatelessWidget {
  const TrackingRiderCard({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  TrackingRiderEntity? get rider => tracking.rider;

  Future<void> _open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRider = rider;
    if (currentRider == null) return const SizedBox.shrink();

    final phone = currentRider.phone?.trim();

    return CustomContainer(
      radiusAll: 12.r,
      color: context.colors.bgSecondary,
      paddingAll: 8.w,
      child: Row(
        children: [
          CustomNetworkImage(
            width: 44.r,
            height: 44.r,
            boxShape: BoxShape.circle,
            imageUrl: currentRider.photoUrl,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: currentRider.name,
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
                SizedBox(height: 4.w),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12.r,
                      color: context.colors.textTertiary,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.star_rounded,
                          size: 12.r,
                          color: context.colors.ratingColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${currentRider.ratingAvg?.toStringAsFixed(1) ?? 0}',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      const TextSpan(text: ' • '),
                      TextSpan(
                        text:
                            'ID ${currentRider.id.length >= 6 ? currentRider.id.substring(currentRider.id.length - 6).toUpperCase() : currentRider.id}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CommonActionIcon(
            onTap: () {
              context.push(
                RoutePaths.riderChatPath(tracking.orderId),
                extra: tracking,
              );
            },
            icon: Assets.icons.chat.path,
          ),
          SizedBox(width: 8.w),
          CommonActionIcon(
            onTap: () => _open(Uri(scheme: 'tel', path: phone)),
            icon: Assets.icons.call.path,
          ),
        ],
      ),
    );
  }

}
