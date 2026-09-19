import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_category_tabs.dart';

class RestaurantAppBarBottom extends StatelessWidget implements PreferredSizeWidget {

  const RestaurantAppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomContainer(
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
  Size get preferredSize => Size.fromHeight(78.h);
}
