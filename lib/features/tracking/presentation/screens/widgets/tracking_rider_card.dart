import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingRiderCard extends StatelessWidget {
  const TrackingRiderCard({super.key, required this.rider});

  final TrackingRiderEntity rider;

  Future<void> _open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = rider.phone?.trim();

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
            imageUrl: rider.photoUrl,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: rider.name,
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
                          text: ' ${rider.ratingAvg?.toStringAsFixed(1) ?? 0}',
                          style: TextStyle(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        const TextSpan(text: ' • '),
                      TextSpan(
                        text:
                            'ID ${rider.id.substring(rider.id.length - 6).toUpperCase()}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildActionButton(
            context: context,
            onTap: () {
              context.push(RoutePaths.riderChat, extra: rider);
            },
            child: Assets.icons.comment.svg(width: 18.r, height: 18.r),
          ),
          SizedBox(width: 8.w),
          _buildActionButton(
            context: context,
            onTap: phone == null || phone.isEmpty
                ? null
                : () => _open(Uri(scheme: 'tel', path: phone)),
            child: Icon(
              Icons.phone_outlined,
              size: 18.r,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return CustomContainer(
      onTap: onTap,
      width: 40.r,
      height: 40.r,
      shape: BoxShape.circle,
      color: context.colors.background,
      bordersColor: context.colors.borderTertiary,
      alignment: Alignment.center,
      child: child,
    );
  }
}
