import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/features/search/domain/entities/search_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.filters,
    required this.onSortTap,
    required this.onPriceTap,
    required this.onRatingTap,
    required this.onFastestTap,
  });

  final SearchFilterSelection filters;
  final VoidCallback onSortTap;
  final VoidCallback onPriceTap;
  final VoidCallback onRatingTap;
  final VoidCallback onFastestTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.w,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        children: [
          CustomFilterChip(
            label: 'Sort',
            isSelected: filters.sort != SearchSort.relevance,
            onTap: onSortTap,
          ),
          SizedBox(width: 8.w),
          CustomFilterChip(
            label: filters.priceLabel,
            isSelected: filters.hasPriceFilter,
            onTap: onPriceTap,
          ),
          SizedBox(width: 8.w),
          CustomFilterChip(
            label: 'Rating 4+',
            isSelected: filters.rating4Plus,
            onTap: onRatingTap,
          ),
          SizedBox(width: 8.w),
          CustomFilterChip(
            label: 'Fastest',
            isSelected: filters.sort == SearchSort.deliveryTime,
            onTap: onFastestTap,
          ),
        ],
      ),
    );
  }
}
