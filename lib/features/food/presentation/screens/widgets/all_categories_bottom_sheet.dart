import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCategoriesBottomSheet extends StatelessWidget {
  const AllCategoriesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.64,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Drag handle
          SizedBox(height: 12.h),
          Container(
            width: 48.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colors.textSecondary.withValues(alpha: 0.2), // using textSecondary for the gray drag handle
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Header: "Category" and "Close"
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Category',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomText(
                    text: 'Close',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          
          // Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 24.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 74 / 90, // using ratio directly
              ),
              itemCount: 20, // Dummy item count
              itemBuilder: (context, index) {
                return const FoodCategoriesWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
