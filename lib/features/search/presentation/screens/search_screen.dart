import 'dart:async';

import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/category_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/h_restaurant_card_shimmer.dart';
import 'package:cheering/features/search/domain/entities/search_sort.dart';
import 'package:cheering/features/search/presentation/blocs/search/search_bloc.dart';
import 'package:cheering/features/search/presentation/blocs/search/search_event.dart';
import 'package:cheering/features/search/presentation/blocs/search/search_state.dart';
import 'package:cheering/features/search/presentation/helpers/search_result_filter.dart';
import 'package:cheering/features/search/presentation/widgets/search_filter_bar.dart';
import 'package:cheering/features/search/presentation/widgets/search_filter_sheet.dart';
import 'package:cheering/features/search/presentation/widgets/search_idle_view.dart';
import 'package:cheering/features/search/presentation/widgets/search_results_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      context.read<SearchBloc>().add(const ClearSearch());
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<SearchBloc>().add(LoadSearch(query: value));
    });
  }

  void _search(String query) {
    _debounce?.cancel();
    _controller
      ..text = query
      ..selection = TextSelection.collapsed(offset: query.length);
    context.read<SearchBloc>().add(LoadSearch(query: query));
  }

  void _apply(SearchFilterSelection filters) {
    context.read<SearchBloc>().add(ApplySearchFilter(filters: filters));
  }

  Future<void> _openFilterSheet() async {
    final bloc = context.read<SearchBloc>();
    final selected = await SearchFilterSheet.show(
      context,
      initial: bloc.state.filters,
      result: bloc.state.result,
    );
    if (selected == null || !mounted) return;
    _apply(selected);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SliverScaffold(
          appBar: CustomSliverAppBar(
            title: 'Search Food',
            toolbarHeight: 40.w,
            expandedHeight: 160.w,
            flexibleChild: const SizedBox.shrink(),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.w),
                    child: CustomTextField(
                      contentPaddingVertical: 12.w,
                      fillColor: context.colors.bgSecondary,
                      controller: _controller,
                      borderColor: Colors.transparent,
                      autofocus: true,
                      validatorType: null,
                      maxLines: 1,
                      textInputAction: TextInputAction.search,
                      prefixIcon: Assets.icons.search.svg(),
                      suffixIcon: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _openFilterSheet,
                        child: Assets.icons.filtter.svg(),
                      ),
                      borderRadius: 99.r,
                      hintText: 'Pizza, burger, biryani...',
                      onChanged: _onQueryChanged,
                      onFieldSubmitted: (value) {
                        _debounce?.cancel();
                        if (value.trim().isEmpty) {
                          context.read<SearchBloc>().add(const ClearSearch());
                          return;
                        }
                        context.read<SearchBloc>().add(
                          LoadSearch(query: value),
                        );
                      },
                    ),
                  ),
                  SearchFilterBar(
                    filters: state.filters,
                    onSortTap: _openFilterSheet,
                    onPriceTap: () {
                      _apply(
                        state.filters.copyWith(
                          priceRange: state.filters.hasPriceFilter
                              ? SearchPriceRange.any
                              : SearchPriceRange.under300,
                        ),
                      );
                    },
                    onRatingTap: () {
                      _apply(
                        state.filters.copyWith(
                          rating4Plus: !state.filters.rating4Plus,
                        ),
                      );
                    },
                    onFastestTap: () {
                      _apply(
                        state.filters.copyWith(
                          sort: state.filters.sort == SearchSort.deliveryTime
                              ? SearchSort.relevance
                              : SearchSort.deliveryTime,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.w),
                ],
              ),
            ),
          ),
          bodyList: _bodyFor(state),
        );
      },
    );
  }

  List<Widget> _bodyFor(SearchState state) {
    if (state.isIdle) {
      return [
        SearchIdleView(
          recentSearches: state.recentSearches,
          onRecentTap: _search,
        ),
      ];
    }

    if (state.result == null) {
      if (state.status == SearchStatus.failure) {
        return [EmptyState(message: state.errorMessage ?? 'Search failed')];
      }
      return [const HRestaurantCardShimmer(count: 6)];
    }

    final filtered = SearchResultFilter.apply(
      result: state.result!,
      filters: state.filters,
    );
    final isEmpty =
        filtered.categories.isEmpty &&
        filtered.restaurants.isEmpty &&
        filtered.items.isEmpty;

    if (state.status == SearchStatus.success && isEmpty) {
      return [const EmptyState(message: 'No results found')];
    }

    return [
      SearchResultsView(
        query: state.query,
        categories: filtered.categories,
        restaurants: filtered.restaurants,
        items: filtered.items,
        onCategoryTap: (CategoryEntity category) => _search(category.name),
      ),
    ];
  }
}
