import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:cheering/features/tracking/presentation/helpers/tracking_status.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingMapSheet extends StatelessWidget {
  const TrackingMapSheet({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final rider = tracking.rider;
    return CustomContainer(
      color: context.colors.background,
      topLeftRadius: 24.r,
      topRightRadius: 24.r,
      paddingHorizontal: 16.w,
      paddingTop: 12.w,
      paddingBottom: 24.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            width: 36.w,
            height: 4.w,
            radiusAll: 99.r,
            color: context.colors.borderSecondary,
          ),
          SizedBox(height: 20.w),
          CustomText(
            text: TrackingStatus.title(tracking),
            fontSize: 20.r,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          CustomText(
            top: 6.w,
            text: TrackingStatus.subtitle(tracking),
            color: context.colors.textTertiary,
            textAlign: TextAlign.center,
          ),
          if (rider != null) ...[
            SizedBox(height: 20.w),
            _RiderCard(rider: rider),
          ],
          SizedBox(height: 20.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'My Order',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: 'Details',
                fontSize: 12.w,
                fontWeight: FontWeight.w500,
                color: context.colors.textTertiary,
              ),
            ],
          ),
          SizedBox(height: 16.w),
          TrackingTimeline(tracking: tracking),
        ],
      ),
    );
  }
}

class _RiderCard extends StatelessWidget {
  const _RiderCard({required this.rider});

  final TrackingRiderEntity rider;

  String get _shortId {
    final id = rider.id;
    if (id.length <= 8) return 'ID $id';
    return 'ID ${id.substring(id.length - 6).toUpperCase()}';
  }

  Future<void> _open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = rider.phone?.trim();
    return CustomContainer(
      radiusAll: 16.r,
      color: context.colors.bgSecondary,
      paddingAll: 12.w,
      child: Row(
        children: [
          CustomNetworkImage(
            width: 48.r,
            height: 48.r,
            boxShape: BoxShape.circle,
            imageUrl: rider.photoUrl,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: rider.name,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
                SizedBox(height: 4.w),
                Row(
                  children: [
                    if (rider.ratingAvg != null) ...[
                      Icon(
                        Icons.star_rounded,
                        size: 14.r,
                        color: const Color(0xFFF59E0B),
                      ),
                      CustomText(
                        left: 2.w,
                        text: rider.ratingAvg!.toStringAsFixed(1),
                        fontSize: 12.r,
                        color: context.colors.textSecondary,
                      ),
                      CustomText(
                        text: '  ·  ',
                        fontSize: 12.r,
                        color: context.colors.textTertiary,
                      ),
                    ],
                    Flexible(
                      child: CustomText(
                        text: _shortId,
                        fontSize: 12.r,
                        color: context.colors.textTertiary,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _CircleAction(
            onTap: phone == null || phone.isEmpty
                ? null
                : () => _open(Uri(scheme: 'sms', path: phone)),
            child: Assets.icons.comment.svg(width: 18.r, height: 18.r),
          ),
          SizedBox(width: 8.w),
          _CircleAction(
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
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
