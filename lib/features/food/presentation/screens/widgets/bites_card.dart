import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BitesItems extends StatelessWidget {
  const BitesItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: CustomNetworkImage(
            width: 124.w,
            height: 176.h,
            borderRadius: 12.r,
            imageUrl:
                'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5',
          ),
        ),
      ),
    );
  }
}
