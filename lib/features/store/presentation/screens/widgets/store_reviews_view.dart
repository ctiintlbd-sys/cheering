import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCardWidget extends StatefulWidget {
  const ReviewCardWidget({super.key});

  @override
  State<ReviewCardWidget> createState() => _ReviewCardWidgetState();
}

class _ReviewCardWidgetState extends State<ReviewCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomNetworkImage(
                backgroundColor: context.colors.bgSecondary,
                height: 38.r,
                width: 38.r,
                boxShape: BoxShape.circle,
                imageUrl: '',
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Jenia Rahman',
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: '2 days ago',
                    fontSize: 12.sp,
                    color: context.colors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Chicken bucket was super crispy and hot on arrival. Delivery was quicker than the estimate too.',
          ),
        ],
      ),
    );
  }

}
