import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';

class BitesCard extends StatelessWidget {
  const BitesCard({
    super.key,
    required this.reel,
    this.onTap,
  });

  final ReelEntity reel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = reel.thumbnailUrl?.isNotEmpty == true
        ? reel.thumbnailUrl!
        : (reel.restaurant.logoUrl ?? reel.restaurant.coverImageUrl ?? '');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 124.w,
        height: 176.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.colors.bgSecondary,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image / Thumbnail
            CustomNetworkImage(
              imageUrl: imageUrl,
              width: 124.w,
              height: 176.w,
              fit: BoxFit.cover,
            ),

            // Subtle dark overlay gradient for readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),

            // Top Play/Duration Tag
            Positioned(
              top: 8.w,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 12.sp,
                    ),
                    if (reel.durationSeconds > 0) ...[
                      SizedBox(width: 2.w),
                      CustomText(
                        text: '${reel.durationSeconds}s',
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Restaurant Info
            Positioned(
              left: 8.w,
              right: 8.w,
              bottom: 8.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (reel.restaurant.logoUrl?.isNotEmpty == true) ...[
                        ClipOval(
                          child: CustomNetworkImage(
                            imageUrl: reel.restaurant.logoUrl,
                            width: 16.r,
                            height: 16.r,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4.w),
                      ],
                      Expanded(
                        child: CustomText(
                          text: reel.restaurant.name,
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.w),
                  Row(
                    children: [
                      if (reel.restaurant.ratingAvg > 0) ...[
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 11.sp,
                        ),
                        SizedBox(width: 2.w),
                        CustomText(
                          text: reel.restaurant.ratingAvg.toStringAsFixed(1),
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(width: 4.w),
                      ],
                      if (reel.restaurant.avgPrepTimeMins > 0)
                        CustomText(
                          text: '• ${reel.restaurant.avgPrepTimeMins}m',
                          color: Colors.white70,
                          fontSize: 9.sp,
                        ),
                      if (reel.restaurant.distanceKm > 0)
                        CustomText(
                          text:
                              ' • ${reel.restaurant.distanceKm.toStringAsFixed(1)}km',
                          color: Colors.white70,
                          fontSize: 9.sp,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
