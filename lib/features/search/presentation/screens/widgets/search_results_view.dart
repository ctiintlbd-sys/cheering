import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/category_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/h_restaurant_card_widget.dart';
import 'package:cheering/features/search/domain/entities/search_result_entity.dart';
import 'package:cheering/features/search/presentation/screens/widgets/search_dish_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({
    super.key,
    required this.query,
    required this.result,
    required this.onCategoryTap,
  });

  final String query;
  final SearchResultEntity result;
  final ValueChanged<CategoryEntity> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (result.categories.isNotEmpty) ...[
          SizedBox(height: 8.w),
          SizedBox(
            height: 40.w,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: result.categories.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final category = result.categories[index];
                return CustomFilterChip(
                  label: category.name,
                  isSelected:
                      query.trim().toLowerCase() ==
                      category.name.toLowerCase(),
                  onTap: () => onCategoryTap(category),
                );
              },
            ),
          ),
        ],
        if (result.restaurants.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 4.w),
            child: const CustomText(
              text: 'Restaurants',
              fontWeight: FontWeight.w600,
            ),
          ),
          for (var index = 0; index < result.restaurants.length; index++)
            CustomItemAnimator(
              index: index,
              animationType: CustomItemAnimationType.slide,
              child: HRestaurantCardWidget(
                restaurant: result.restaurants[index],
              ),
            ),
        ],
        if (result.items.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 4.w),
            child: const CustomText(
              text: 'Dishes',
              fontWeight: FontWeight.w600,
            ),
          ),
          for (var index = 0; index < result.items.length; index++)
            CustomItemAnimator(
              index: index,
              animationType: CustomItemAnimationType.slide,
              child: SearchDishTile(item: result.items[index]),
            ),
        ],
        SizedBox(height: 24.w),
      ],
    );
  }
}
