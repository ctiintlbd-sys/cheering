import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreCategoriesWidget extends StatelessWidget {
  const StoreCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      height: 88.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomContainer(
            width: 60.r,
            height: 60.r,
            radiusAll: 8.r,
            alignment: Alignment.center,
            paddingAll: 8.r,
            color: context.colors.primaryLight,
            child: CustomNetworkImage(fit: BoxFit.contain, imageUrl: ''),
          ),

          SizedBox(height: 8.w),

          SizedBox(
            width: 60.w,
            height: 20.w,
            child: CustomText(
              text: 'Grocery',
              fontWeight: FontWeight.w500,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
