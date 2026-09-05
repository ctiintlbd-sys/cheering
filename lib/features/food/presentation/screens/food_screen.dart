import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/delivery_title_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_flexible_background.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_categories_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/super_deals_card.dart';
import 'package:cheering/features/food/presentation/screens/widgets/bites_card.dart';
import 'package:cheering/features/food/presentation/screens/widgets/top_restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      onRefresh: ()async{},
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

        SizedBox(
          height: 98.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: const FoodCategoriesWidget(),
              );
            },
          ),
        ),

        SizedBox(height: 24.h),
        SectionHeaderWidget(
          title: 'Super Deals 🔥',
          onTap: () {},
        ).horizontal(16.w),
        SizedBox(height: 10.h),
        SizedBox(
          height: 228.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => const SuperDealsCard(),
          ),
        ),

        SizedBox(height: 28.h),
        SectionHeaderWidget(
          title: 'Bites 🔥',
          subtitle: 'Discover what everyone\'s eating',
          onTap: () {},
        ).horizontal(16.w),
        SizedBox(height: 8.h),

        BitesItems(),

        SizedBox(height: 20.h),
        SectionHeaderWidget(
          title: 'Top Restaurants',
          onTap: () {},
        ).horizontal(16.w),
        SizedBox(height: 10.h),
        SizedBox(
          height: 202.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => Padding(
              padding:  EdgeInsets.symmetric(vertical: 4.h),
              child: const TopRestaurantCard(),
            ),
          ),
        ),

        SizedBox(height: 120.h),
      ],
    );
  }
}
