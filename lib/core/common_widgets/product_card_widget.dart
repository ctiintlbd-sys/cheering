import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138.w,
      height: 176.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            backgroundColor: context.colors.bgSecondary,
            height: 124.w,
            borderRadius: 12.r,
            imageUrl:
                'https://images.unsplash.com/photo-1513104890138-7c749659a591',
          ),

          SizedBox(height: 10.w),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
                fontFamily: FontFamily.sFPro,
              ),
              children: [
                TextSpan(text: '৳150  '),
                TextSpan(
                  text: '৳110',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w400,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          CustomText(
            text: 'Pizza (4pcs)',
            maxLines: 1,
            color: context.colors.textSecondary,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
