import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/common_widgets/custom_filter_chip.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_category_tabs.dart';

class StoreAppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  final bool showReviews;

  const StoreAppBarBottom({super.key, required this.showReviews});

  @override
  Widget build(BuildContext context) {
    return showReviews
        ? CustomContainer(
            topLeftRadius: 32.r,
            topRightRadius: 32.r,
            color: context.colors.background,
            height: 44.h,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => SizedBox(width: 6.w),
              itemBuilder: (context, index) {
                final isSelected = index == 0;

                return CustomFilterChip(
                  label: 'All',
                  isSelected: isSelected,
                  onTap: () {},
                );
              },
            ),
          )
        : CustomContainer(
            topLeftRadius: 32.r,
            topRightRadius: 32.r,
            color: context.colors.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomTextField(
                    validator: (_) => null,
                    contentPaddingVertical: 12.h,
                    hintText: 'Search Menu',
                    prefixIcon: Assets.icons.search.svg(),
                    fillColor: context.colors.bgSecondary,
                    borderColor: context.colors.background,
                    borderRadius: 99.r,
                  ),
                ),
                SizedBox(height: 20.h),
                const MenuCategoryTabs(),
              ],
            ),
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(showReviews ? 44.h : 78.h);
}
