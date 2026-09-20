import 'package:cheering/core/common_widgets/common_widgets.dart';
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
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        title: categoryName,
        expandedHeight: 96.w,
        flexibleChild: SizedBox.shrink(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(28.w),
          child: SizedBox(
            height: 40.w,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final isSelected = index == 2;
                return CustomFilterChip(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.w,
                  ),
                  label: 'Sort',
                  labelSize: 14.r,
                  isSelected: isSelected,
                  onTap: () {},
                );
              },
            ),
          ),
        ),
      ),
      bodyList: [
        SizedBox(height: 26.w),
        CustomText(
          text: '36 places serving $categoryName',
          color: context.colors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 12.w),

        SliverList.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(height: 4.w),
          itemBuilder: (context, index) {
            return CustomItemAnimator(
              index: index,
              animationType: CustomItemAnimationType.slide,
              child: const FoodCardWidget(),
            );
          },
        ),

        SizedBox(height: 120.w),
      ],
    );
  }
}
