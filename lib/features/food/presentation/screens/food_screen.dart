import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/delivery_title_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_flexible_background.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(
        toolbarHeight: 0,
        expandedHeight: 234.h,
        backgroundColor: context.colors.background,
        collapsedBgColor: context.colors.primary,
        flexibleChild: const DeliveryTitleWidget(
          address: 'House 25, Banani Rd 11...',
        ),
        flexibleBackground: const FoodFlexibleBackground(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(58.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
            child: CustomTextField(
              onTap: () {},
              readOnly: true,
              prefixIcon: Assets.icons.search.svg(),
              suffixIcon: Assets.icons.filtter.svg(),
              borderRadius: 99.r,
              fillColor: context.colors.background,
              borderColor: context.colors.borderSecondary,
              hintText: 'Search for restaurant...',
            ),
          ),
        ),
      ),
      bodyList: [
        SizedBox(height: 20.h),

        const FoodCategoriesWidget(),
      ],
    );
  }
}
