import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';
import 'package:cheering/features/food/presentation/models/filter_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantFiltersBar extends StatelessWidget {
  final List<FilterData> filters;
  final int? selectedIndex;
  final Function(int?, RestaurantQueryParams?) onFilterChanged;

  const RestaurantFiltersBar({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.w,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedIndex == index;

          return CustomFilterChip(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.w,
            ),
            label: filter.label,
            labelSize: 14.r,
            isSelected: isSelected,
            onTap: () {
              if (isSelected) {
                onFilterChanged(null, null);
              } else {
                // Select
                onFilterChanged(index, filter.params);
              }
            },
          );
        },
      ),
    );
  }
}
