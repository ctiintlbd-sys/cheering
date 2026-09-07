import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(
        title: categoryName,
      ),
      bodyList: [
        SizedBox(height: 8.h),
        
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              _buildFilterChip(context, 'Sort', false),
              SizedBox(width: 8.w),
              _buildFilterChip(context, 'Under ৳300', false),
              SizedBox(width: 8.w),
              _buildFilterChip(context, 'Rating 4+', true),
              SizedBox(width: 8.w),
              _buildFilterChip(context, 'Fastest', false),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        
        // Subtitle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: '36 places serving $categoryName',
            fontSize: 14.sp,
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),

        // Store List (SliverList is recognized natively by SliverScaffold)
        SliverList.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(height: 4.h),
          itemBuilder: (context, index) {
            return CustomItemAnimator(
              index: index,
              animationType: CustomItemAnimationType.slide,
              child: const FoodCardWidget(),
            );
          },
        ),

        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.primary : context.colors.background,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected 
              ? context.colors.primary 
              : (context.colors.borderSecondary ?? Colors.grey.shade300),
        ),
      ),
      child: CustomText(
        text: label,
        color: isSelected ? Colors.white : context.colors.textSecondary,
        fontSize: 13.sp,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }
}
