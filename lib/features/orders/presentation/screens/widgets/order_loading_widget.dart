import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OrderLoadingWidget extends StatelessWidget {
  const OrderLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
      child: Shimmer.fromColors(
        baseColor: context.colors.borderTertiary,
        highlightColor: context.colors.background,
        child: Column(
          children: [
            for (var i = 0; i < 4; i++) ...[
              Container(
                width: double.infinity,
                height: 168.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              if (i < 3) SizedBox(height: 12.w),
            ],
          ],
        ),
      ),
    );
  }
}
