import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/features/search/domain/entities/search_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.sort,
    required this.priceRange,
    required this.under300,
    required this.rating4Plus,
    required this.onSortTap,
    required this.onPriceTap,
    required this.onRating4PlusTap,
    required this.onFastestTap,
  });

  final SearchSort sort;
  final SearchPriceRange priceRange;
  final bool under300;
  final bool rating4Plus;
  final VoidCallback onSortTap;
  final VoidCallback onPriceTap;
  final VoidCallback onRating4PlusTap;
  final VoidCallback onFastestTap;

  bool get _hasPriceFilter =>
      under300 || priceRange != SearchPriceRange.any;

  String get _priceLabel => switch (priceRange) {
    SearchPriceRange.under200 => 'Under ৳200',
    SearchPriceRange.from200to500 => '৳200 - ৳500',
    SearchPriceRange.over500 => '৳500+',
    SearchPriceRange.any => 'Under ৳300',
  };

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
            label: _priceLabel,
            isSelected: _hasPriceFilter,
            onTap: onPriceTap,
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
