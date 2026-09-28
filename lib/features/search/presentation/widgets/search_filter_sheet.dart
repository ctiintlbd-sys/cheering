import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/search/domain/entities/search_result_entity.dart';
import 'package:cheering/features/search/domain/entities/search_sort.dart';
import 'package:cheering/features/search/presentation/blocs/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({
    super.key,
    required this.initial,
    this.result,
    this.under300 = false,
    this.rating4Plus = false,
  });

  final SearchFilterSelection initial;
  final SearchResultEntity? result;
  final bool under300;
  final bool rating4Plus;

  static Future<SearchFilterSelection?> show(
    BuildContext context, {
    required SearchFilterSelection initial,
    SearchResultEntity? result,
    bool under300 = false,
    bool rating4Plus = false,
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
        under300: under300,
        rating4Plus: rating4Plus,
      ),
    );
  }

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late SearchSort _sort;
  late SearchPriceRange _priceRange;
  late SearchDietary _dietary;

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
    _sort = widget.initial.sort;
    _priceRange = widget.initial.priceRange;
    _dietary = widget.initial.dietary;
  }

  SearchFilterSelection get _selection => SearchFilterSelection(
    sort: _sort,
    priceRange: _priceRange,
    dietary: _dietary,
  );

  int get _resultCount => SearchState.countVisible(
    result: widget.result,
    selection: _selection,
    under300: widget.under300 && _priceRange == SearchPriceRange.any,
    rating4Plus: widget.rating4Plus,
  );

  void _reset() {
    setState(() {
      _sort = SearchSort.relevance;
      _priceRange = SearchPriceRange.any;
      _dietary = SearchDietary.any;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = widget.result != null;
    final buttonLabel = hasResults
        ? 'Show $_resultCount results'
        : 'Show results';

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
                    fontSize: 20.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomText(
                  text: 'Reset',
                  fontSize: 14.r,
                  fontWeight: FontWeight.w500,
                  color: context.colors.primary,
                  onTap: _reset,
                ),
              ],
            ),
            SizedBox(height: 24.w),
            _sectionTitle('Sort by'),
            SizedBox(height: 12.w),
            _chipWrap(
              children: [
                for (final option in _sortOptions)
                  _FilterChoiceChip(
                    label: option.$2,
                    isSelected: _sort == option.$1,
                    onTap: () => setState(() => _sort = option.$1),
                  ),
              ],
            ),
            SizedBox(height: 24.w),
            _sectionTitle('Price range'),
            SizedBox(height: 12.w),
            _chipWrap(
              children: [
                for (final option in _priceOptions)
                  _FilterChoiceChip(
                    label: option.$2,
                    isSelected: _priceRange == option.$1,
                    onTap: () => setState(() {
                      _priceRange = _priceRange == option.$1
                          ? SearchPriceRange.any
                          : option.$1;
                    }),
                  ),
              ],
            ),
            SizedBox(height: 24.w),
            _sectionTitle('Dietary'),
            SizedBox(height: 12.w),
            _chipWrap(
              children: [
                for (final option in _dietaryOptions)
                  _FilterChoiceChip(
                    label: option.$2,
                    isSelected: _dietary == option.$1,
                    onTap: () => setState(() {
                      _dietary = _dietary == option.$1
                          ? SearchDietary.any
                          : option.$1;
                    }),
                  ),
              ],
            ),
            SizedBox(height: 28.w),
            CustomButton(
              label: buttonLabel,
              height: 52.w,
              radius: 99,
              fontWeight: FontWeight.w600,
              fontSize: 16.r,
              onPressed: () => Navigator.of(context).pop(_selection),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return CustomText(
      text: text,
      fontSize: 14.r,
      fontWeight: FontWeight.w500,
      color: context.colors.textSecondary,
    );
  }

  Widget _chipWrap({required List<Widget> children}) {
    return Wrap(spacing: 8.w, runSpacing: 8.w, children: children);
  }
}

class _FilterChoiceChip extends StatelessWidget {
  const _FilterChoiceChip({
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primaryLight
              : context.colors.background,
          borderRadius: BorderRadius.circular(99.r),
          border: Border.all(
            color: isSelected
                ? context.colors.primaryLight
                : context.colors.outline,
          ),
        ),
        child: CustomText(
          text: label,
          fontSize: 14.r,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          color: isSelected
              ? context.colors.primary
              : context.colors.textPrimary,
        ),
      ),
    );
  }
}
