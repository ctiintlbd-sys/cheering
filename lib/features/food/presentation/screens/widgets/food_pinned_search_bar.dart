import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodPinnedSearchBar extends StatelessWidget implements PreferredSizeWidget {
  const FoodPinnedSearchBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(0);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, 0), // Adjust this offset if you need exact overlap
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 0.h),
        child: CustomTextField(
          onTap: () {},
          readOnly: true,
          prefixIcon: Assets.icons.search.svg(),
          suffixIcon: Assets.icons.filtter.svg(),
          borderRadius: 99.r,
          fillColor: context.colors.background,
          borderColor: context.colors.borderSecondary,
          hintText: 'Search food...',
        ),
      ),
    );
  }
}
