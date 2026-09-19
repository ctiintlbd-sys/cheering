import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StoreCardWidget extends StatelessWidget {
  const StoreCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(RoutePaths.storeDetails);
      },
      child: SizedBox(
        width: 174.w,
        height: 194.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              height: 124.h,
              borderRadius: 12.r,
              imageUrl:
                  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
            ),
            CustomText(
              top: 10.h,
              text: 'KFC - Badda',
              fontWeight: FontWeight.w500,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  height: 1.55,
                  fontSize: 12.sp,
                  color: context.colors.textTertiary,
                ),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.directions_bike,
                      color: context.colors.iconSecondary,
                      size: 12.r,
                    ),
                  ),
                  TextSpan(text: ' ৳40 '),
                  TextSpan(text: '•'),
                  TextSpan(text: ' 1.2Km\n'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.star,
                      color: context.colors.ratingColor,
                      size: 12.r,
                    ),
                  ),
                  TextSpan(text: ' 4.3 (27) '),
                  TextSpan(text: '•'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.access_time,
                      color: context.colors.iconSecondary,
                      size: 12.r,
                    ),
                  ),
                  TextSpan(text: ' 15-30 mins'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
