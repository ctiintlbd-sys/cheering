import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_category_tabs.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';

class RestaurantAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  final List<MenuCategoryEntity> categories;
  final ValueNotifier<int> activeIndexNotifier;
  final ValueChanged<int> onTabTapped;

  const RestaurantAppBarBottom({
    super.key,
    required this.categories,
    required this.activeIndexNotifier,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      topLeftRadius: 32.r,
      topRightRadius: 32.r,
      color: context.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomTextField(
              validator: (_) => null,
              contentPaddingVertical: 12.w,
              hintText: 'Search Menu',
              prefixIcon: Assets.icons.search.svg(),
              fillColor: context.colors.bgSecondary,
              borderColor: context.colors.background,
              borderRadius: 99.r,
            ),
          ),
          SizedBox(height: 20.w),
          MenuCategoryTabs(
            categories: categories,
            activeIndexNotifier: activeIndexNotifier,
            onTabTapped: onTabTapped,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(122.w);
}
