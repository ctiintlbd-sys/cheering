import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/search/domain/entities/search_result_entity.dart';
import 'package:cheering/features/search/domain/entities/search_sort.dart';
import 'package:cheering/features/search/presentation/helpers/search_result_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({
    super.key,
    required this.initial,
    this.result,
  });

  final SearchFilterSelection initial;
  final SearchResultEntity? result;

  static Future<SearchFilterSelection?> show(
    BuildContext context, {
    required SearchFilterSelection initial,
    SearchResultEntity? result,
  }) {
    return showModalBottomSheet<SearchFilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => SearchFilterSheet(
        initial: initial,
        result: result,
      ),
    );
  }

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late SearchFilterSelection _filters;

  static const _sortOptions = <(SearchSort, String)>[
    (SearchSort.relevance, 'Relevance'),
    (SearchSort.priceLowToHigh, 'Price: low to high'),
    (SearchSort.rating, 'Rating'),
    (SearchSort.deliveryTime, 'Delivery time'),
  ];

  static const _priceOptions = <(SearchPriceRange, String)>[
    (SearchPriceRange.under200, 'Under ৳200'),
    (SearchPriceRange.from200to500, '৳200 - ৳500'),
    (SearchPriceRange.over500, '৳500+'),
  ];

  static const _dietaryOptions = <(SearchDietary, String)>[
    (SearchDietary.healthy, 'Healthy'),
    (SearchDietary.vegetarian, 'Vegetarian'),
    (SearchDietary.spicy, 'Spicy'),
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.initial;
  }

  int get _resultCount {
    final result = widget.result;
    if (result == null) return 0;
    final filtered = SearchResultFilter.apply(
      result: result,
      filters: _filters,
    );
    return filtered.categories.length +
        filtered.restaurants.length +
        filtered.items.length;
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabel = widget.result == null
        ? 'Show results'
        : 'Show $_resultCount results';

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.w, 20.w, 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CustomContainer(
                width: 36.w,
                height: 4.w,
                radiusAll: 99.r,
                color: context.colors.borderSecondary,
              ),
            ),
            SizedBox(height: 20.w),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: 'Filter & Sort',
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomText(
                  text: 'Reset',
                  fontWeight: FontWeight.w500,
                  color: context.colors.primary,
                  onTap: () => setState(() {
                    _filters = const SearchFilterSelection();
                  }),
                ),
              ],
            ),
            SizedBox(height: 24.w),
            _sectionTitle('Sort by'),
            SizedBox(height: 12.w),
            _chips([
              for (final option in _sortOptions)
                _Chip(
                  label: option.$2,
                  isSelected: _filters.sort == option.$1,
                  onTap: () => setState(() {
                    _filters = _filters.copyWith(sort: option.$1);
                  }),
                ),
            ]),
            SizedBox(height: 24.w),
            _sectionTitle('Price range'),
            SizedBox(height: 12.w),
            _chips([
              for (final option in _priceOptions)
                _Chip(
                  label: option.$2,
                  isSelected: _filters.priceRange == option.$1,
                  onTap: () => setState(() {
                    _filters = _filters.copyWith(
                      priceRange: _filters.priceRange == option.$1
                          ? SearchPriceRange.any
                          : option.$1,
                    );
                  }),
                ),
            ]),
            SizedBox(height: 24.w),
            _sectionTitle('Dietary'),
            SizedBox(height: 12.w),
            _chips([
              for (final option in _dietaryOptions)
                _Chip(
                  label: option.$2,
                  isSelected: _filters.dietary == option.$1,
                  onTap: () => setState(() {
                    _filters = _filters.copyWith(
                      dietary: _filters.dietary == option.$1
                          ? SearchDietary.any
                          : option.$1,
                    );
                  }),
                ),
            ]),
            SizedBox(height: 28.w),
            CustomButton(
              label: buttonLabel,
              onPressed: () => Navigator.of(context).pop(_filters),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return CustomText(
      text: text,
      fontSize: 12.r,
      fontWeight: FontWeight.w500,
      color: context.colors.textSecondary,
    );
  }

  Widget _chips(List<Widget> children) {
    return Wrap(spacing: 8.w, runSpacing: 8.w, children: children);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primaryLight
              : context.colors.background,
          borderRadius: BorderRadius.circular(99.r),
          border: Border.all(
            color: isSelected
                ? context.colors.primaryLight
                : context.colors.borderTertiary,
          ),
        ),
        child: CustomText(
          text: label,
          fontSize: 12.r,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? context.colors.primary
              : context.colors.textPrimary,
        ),
      ),
    );
  }
}
