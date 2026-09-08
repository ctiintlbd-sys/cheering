import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemWidget extends StatelessWidget {
  final int index;
  
  const MenuItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // Just simulating a different item for index 0 to show quantity state
    final hasQuantity = index == 0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            width: 80.r,
            height: 80.r,
            borderRadius: 12.r,
            imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
          ),
          SizedBox(width: 12.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: index == 1 ? 'Classic Cheeseburger' : (index == 2 ? 'Spaghetti Carbonara' : 'Fried Chicken Bucket'),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: '8 pcs crispy fried chicken, spiced',
                  color: context.colors.textSecondary,
                  fontSize: 12.sp,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: index == 1 ? '৳450' : (index == 2 ? '৳520' : '৳650'),
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                    
                    hasQuantity ? _buildQuantityControl(context) : _buildAddButton(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.primary.withValues(alpha: 0.3)),
        ),
        child: Icon(Icons.add, color: context.colors.primary, size: 18.r),
      ),
    );
  }

  Widget _buildQuantityControl(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgSecondary ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Icon(Icons.remove, color: context.colors.textSecondary, size: 16.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CustomText(
              text: '1',
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.add, color: context.colors.white, size: 16.r),
            ),
          ),
        ],
      ),
    );
  }
}
