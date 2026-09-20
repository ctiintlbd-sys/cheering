import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomContainer(
        onTap: () {},
        width: double.infinity,
        paddingAll: 16.w,
        radiusAll: 16,
        bordersColor: context.colors.borderSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1513104890138-7c749659a591',
                  height: 72.r,
                  width: 72.r,
                  borderRadius: 12.r,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Fried Chicken Bucket',
                        fontSize: 16.r,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(
                                height: 1.88,
                                fontSize: 14.r,
                                color: context.colors.textTertiary,
                              ),
                              children: [
                                TextSpan(text: '3 Items • '),
                                TextSpan(text: 'COD\n'),
                                TextSpan(text: '24 Jun, 7:45 Pm'),
                              ],
                            ),
                          ),

                          CustomContainer(
                            paddingHorizontal: 12.w,
                            paddingVertical: 4.w,
                            color: context.colors.bgSuccessSecondary.withValues(
                              alpha: 0.1,
                            ),
                            radiusAll: 36.r,
                            child: CustomText(
                              text: 'Delivered',
                              fontSize: 12.r,
                              fontWeight: FontWeight.w500,
                              color: context.colors.bgSuccessSecondary,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.w),
            Divider(color: context.colors.borderSecondary),
            SizedBox(height: 10.w),

            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: '৳650.00',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomContainer(
                  radiusAll: 38.r,
                  paddingHorizontal: 12.w,
                  paddingVertical: 8.w,
                  bordersColor: context.colors.borderSecondary,
                  child: CustomText(
                    fontSize: 12.r,
                    fontWeight: FontWeight.w600,
                    text: 'Rate Order',
                  ),
                ),
                SizedBox(width: 8.w),
                CustomContainer(
                  radiusAll: 38.r,
                  paddingHorizontal: 12.w,
                  paddingVertical: 8.w,
                  color: context.colors.primary,
                  child: CustomText(
                    fontSize: 12.r,
                    fontWeight: FontWeight.w600,
                    color: context.colors.white,
                    text: 'Order Again',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
