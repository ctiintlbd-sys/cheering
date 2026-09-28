import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/features/search/domain/entities/search_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.sort,
    required this.under300,
    required this.rating4Plus,
    required this.onSortTap,
    required this.onUnder300Tap,
    required this.onRating4PlusTap,
    required this.onFastestTap,
  });

  final SearchSort sort;
  final bool under300;
  final bool rating4Plus;
  final VoidCallback onSortTap;
  final VoidCallback onUnder300Tap;
  final VoidCallback onRating4PlusTap;
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
            isSelected: sort != SearchSort.relevance,
            onTap: onSortTap,
          ),
          SizedBox(width: 8.w),
          CustomFilterChip(
            label: 'Under ৳300',
            isSelected: under300,
            onTap: onUnder300Tap,
          ),
          SizedBox(width: 8.w),
          CustomFilterChip(
            label: 'Rating 4+',
            isSelected: rating4Plus,
            onTap: onRating4PlusTap,
          ),
          SizedBox(width: 8.w),
          CustomFilterChip(
            label: 'Fastest',
            isSelected: sort == SearchSort.deliveryTime,
            onTap: onFastestTap,
          ),
        ],
      ),
    );
  }
}
