import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuCategoryTabs extends StatefulWidget {
  const MenuCategoryTabs({super.key});

  @override
  State<MenuCategoryTabs> createState() => _MenuCategoryTabsState();
}

class _MenuCategoryTabsState extends State<MenuCategoryTabs> {
  final List<String> categories = [
    'Pizza',
    'Burger',
    'Pizza',
    'Sushi',
    'Tacos',
    'Pasta',
    'Sushi',
    'Tacos',
    'Pasta',
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      horizontalMargin: 16.w,
      height: 40.h,
      border: Border(bottom: BorderSide(color: context.colors.borderSecondary)),

      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 22.w),
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? context.colors.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: CustomText(
                text: categories[index],
                color: isSelected
                    ? context.colors.primary
                    : context.colors.textSecondary,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}
