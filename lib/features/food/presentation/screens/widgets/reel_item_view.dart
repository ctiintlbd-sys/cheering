import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import 'preview_video.dart';

class ReelItemView extends StatelessWidget {
  final ReelEntity reel;
  final bool isActive;

  const ReelItemView({
    super.key,
    required this.reel,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = reel.thumbnailUrl?.isNotEmpty == true
        ? reel.thumbnailUrl!
        : (reel.restaurant.logoUrl ??
              reel.restaurant.coverImageUrl ??
              '');

    return PreviewVideo(
      videoUrl: reel.videoUrl,
      isActive: isActive,
      isMuted: false,
      enableTapToPlayPause: true,
      placeholder: CustomNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      ),
      overlayBuilder: (context, controller) {
        final isInitialized =
            controller != null && controller.value.isInitialized;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 200.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Content & action details
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 10.h,
              left: 16.w,
              right: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: reel.restaurant.name,
                          color: context.colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                        ),
                      ),
                      CustomContainer(
                        radiusAll: 10.r,
                        paddingVertical: 6.w,
                        paddingHorizontal: 10.w,
                        color: context.colors.white,
                        onTap: () {
                          context.push(
                            RoutePaths.storeDetails(reel.restaurant.id),
                          );
                        },
                        child: CustomText(
                          text: 'View',
                          color: context.colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  if (isInitialized)
                    VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: context.colors.white,
                        bufferedColor:
                            context.colors.white.withValues(alpha: 0.3),
                        backgroundColor:
                            context.colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  SizedBox(height: 12.h),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.white,
                        fontFamily: FontFamily.sFPro,
                      ),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.star,
                            color: context.colors.ratingColor,
                            size: 12.r,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' ${reel.restaurant.ratingAvg} (${reel.restaurant.ratingCount})  •  ',
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.access_time,
                            color: context.colors.white,
                            size: 12.r,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' ${reel.restaurant.avgPrepTimeMins} mins  •  ',
                        ),
                        TextSpan(
                          text:
                              '${reel.restaurant.distanceKm > 0 ? (reel.restaurant.distanceKm % 1 == 0 ? reel.restaurant.distanceKm.toInt() : reel.restaurant.distanceKm.toStringAsFixed(1)) : reel.restaurant.distanceKm}Km',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
