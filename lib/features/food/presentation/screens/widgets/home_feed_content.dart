import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:cheering/core/router/route_args.dart";

import 'package:go_router/go_router.dart';
import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/helpers/bottom_sheet_helper.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/category_entity.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';
import 'package:cheering/features/food/presentation/blocs/home_feed/home_feed_bloc.dart';
import 'all_categories_bottom_sheet.dart';
import 'food_categories_widget.dart';
import 'super_deals_card.dart';

const int _kMaxVisibleCategories = 10;

// CategoriesSection
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key, required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final showSeeAll = categories.length > _kMaxVisibleCategories;
    final itemCount = showSeeAll
        ? _kMaxVisibleCategories + 1
        : categories.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 98.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              if (showSeeAll && index == _kMaxVisibleCategories) {
                return SeeAllCategoriesWidget(
                  onTap: () {
                    BottomSheetHelper.showSheet(
                      context: context,
                      child: BlocProvider.value(
                        value: context.read<HomeFeedBloc>(),
                        child: const AllCategoriesBottomSheet(),
                      ),
                    );
                  },
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                child: CustomItemAnimator(
                  index: index,
                  child: FoodCategoriesWidget(category: categories[index]),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.w),
      ],
    );
  }
}

// SuperDealsSection
class SuperDealsSection extends StatelessWidget {
  const SuperDealsSection({super.key, required this.promoted});

  final List<RestaurantEntity> promoted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeaderWidget(
          title: 'Super Deals 🔥',
          onTap: () {
            context.push(RoutePaths.restaurantList, extra: RestaurantListArgs(title: 'Super Deals 🔥', params: const RestaurantQueryParams(sort: 'offers')));
          },
        ).horizontal(16.w),
        SizedBox(height: 10.w),
        SizedBox(
          height: 228.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: promoted.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return CustomItemAnimator(
                index: index,
                child: const SuperDealsCard(),
              );
            },
          ),
        ),
        SizedBox(height: 28.w),
      ],
    );
  }
}

// Nearby
class NearbyRestaurantsSection extends StatelessWidget {
  const NearbyRestaurantsSection({super.key, required this.nearby});

  final List<RestaurantEntity> nearby;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeaderWidget(
          title: 'Nearby', 
          onTap: () {
            context.push(RoutePaths.restaurantList, extra: RestaurantListArgs(title: 'Nearby Restaurants', params: const RestaurantQueryParams(radius: 5000)));
          }
        ).horizontal(16.w),
        SizedBox(height: 10.w),
        SizedBox(
          height: 202.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: nearby.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                child: CustomItemAnimator(
                  index: index,
                  child: RestaurantCardWidget(restaurant: nearby[index]),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 28.w),
      ],
    );
  }
}

class TopRestaurantsSection extends StatelessWidget {
  const TopRestaurantsSection({super.key, required this.topRated});

  final List<RestaurantEntity> topRated;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeaderWidget(
          title: 'Top Restaurants',
          onTap: () {
            context.push(RoutePaths.restaurantList, extra: RestaurantListArgs(title: 'Top Restaurants', params: const RestaurantQueryParams(minRating: 4.0)));
          }
        ).horizontal(16.w),
        SizedBox(height: 10.w),
        SizedBox(
          height: 202.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: topRated.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                child: CustomItemAnimator(
                  index: index,
                  child: RestaurantCardWidget(restaurant: topRated[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
