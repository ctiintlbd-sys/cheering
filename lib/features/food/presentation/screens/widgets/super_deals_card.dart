import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:cheering/core/router/route_paths.dart';

class SuperDealsCard extends StatelessWidget {
  const SuperDealsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {
        context.push(RoutePaths.itemDetails);
      },
      verticalMargin: 4.w,
      width: 248.w,
      height: 220.w,
      radiusAll: 12.r,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          CustomNetworkImage(
            borderRadius: 12.r,
            imageUrl:
                'https://images.unsplash.com/photo-1513104890138-7c749659a591',
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  context.colors.black.withValues(alpha: 0.85),
                  context.colors.black.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          // Top Badges
          Positioned(
            top: 12.w,
            left: 12.w,
            child: CustomContainer(
              alignment: Alignment.center,
              color: context.colors.primaryLight.withValues(alpha: 0.8),
              radiusAll: 16.r,
              paddingVertical: 4.w,
              paddingHorizontal: 8.w,
              child: CustomText(
                text: '20%Off',
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12.r,
              ),
            ),
          ),
          // Bottom Info
          Positioned(
            bottom: 12.w,
            left: 12.w,
            right: 12.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: 'Tandoori Pizza',
                        color: context.colors.white,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomText(
                      text: '৳350',
                      color: context.colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(height: 4.w),
                CustomText(
                  text: 'Pizza House • Fast Food',
                  color: context.colors.white.withValues(alpha: 0.66),
                  fontSize: 12.r,
                ),
                SizedBox(height: 4.w),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      color: context.colors.white.withValues(alpha: 0.8),
                      fontSize: 12.r,
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
                      TextSpan(text: ' 4.5 '),
                      TextSpan(text: '•'),
                      TextSpan(text: ' '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.directions_bike,
                          color: context.colors.white.withValues(alpha: 0.8),
                          size: 12.r,
                        ),
                      ),
                      TextSpan(text: ' ৳65(1.5Km) '),
                      TextSpan(text: '•'),
                      TextSpan(text: ' '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.access_time,
                          color: context.colors.white.withValues(alpha: 0.8),
                          size: 12.r,
                        ),
                      ),
                      TextSpan(text: ' 10-20 mins'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
