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
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
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

  void _fillAndSearch(String query) {
    _debounce?.cancel();
    _controller
      ..text = query
      ..selection = TextSelection.collapsed(offset: query.length);
    context.read<SearchBloc>().add(LoadSearch(query: query));
  }

  void _onCategoryTap(CategoryEntity category) {
    _fillAndSearch(category.name);
  }

  Future<void> _openFilterSheet() async {
    final bloc = context.read<SearchBloc>();
    final state = bloc.state;
    final selected = await SearchFilterSheet.show(
      context,
      initial: state.filterSelection,
      result: state.result,
    );
    if (selected == null || !mounted) return;
    bloc.add(ApplySearchFilter(selection: selected));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SliverScaffold(
          appBar: CustomSliverAppBar(
            title: 'Search Food',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(104.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.w),
                    child: CustomTextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      validatorType: null,
                      maxLength: 100,
                      maxLines: 1,
                      textInputAction: TextInputAction.search,
                      prefixIcon: Assets.icons.search.svg(),
                      suffixIcon: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _openFilterSheet,
                        child: Assets.icons.filtter.svg(),
                      ),
                      borderRadius: 99.r,
                      fillColor: context.colors.bgSecondary,
                      borderColor: context.colors.borderSecondary,
                      hintText: 'Pizza, burger, biryani...',
                      onChanged: _onQueryChanged,
                      onFieldSubmitted: (value) {
                        _debounce?.cancel();
                        if (value.trim().isEmpty) {
                          context.read<SearchBloc>().add(const ClearSearch());
                          return;
                        }
                        context.read<SearchBloc>().add(LoadSearch(query: value));
                      },
                    ),
                  ),
                  SearchFilterBar(
                    sort: state.sort,
                    under300: state.under300,
                    rating4Plus: state.rating4Plus,
                    onSortTap: _openFilterSheet,
                    onUnder300Tap: () {
                      context.read<SearchBloc>().add(
                        ApplySearchFilter(
                          selection: state.filterSelection.copyWith(
                            under300: !state.under300,
                            priceRange: SearchPriceRange.any,
                          ),
                        ),
                      );
                    },
                    onRating4PlusTap: () {
                      context.read<SearchBloc>().add(
                        ApplySearchFilter(
                          selection: state.filterSelection.copyWith(
                            rating4Plus: !state.rating4Plus,
                          ),
                        ),
                      );
                    },
                    onFastestTap: () {
                      context.read<SearchBloc>().add(
                        ApplySearchFilter(
                          selection: state.filterSelection.copyWith(
                            sort: state.sort == SearchSort.deliveryTime
                                ? SearchSort.relevance
                                : SearchSort.deliveryTime,
                          ),
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
          onRecentTap: _fillAndSearch,
        ),
      ];
    }

    if (state.status == SearchStatus.loading && state.result == null) {
      return [const HRestaurantCardShimmer(count: 6)];
    }

    if (state.status == SearchStatus.failure && state.result == null) {
      return [EmptyState(message: state.errorMessage ?? 'Search failed')];
    }

    if (state.status == SearchStatus.success &&
        !SearchResultFilter.hasVisibleResults(
          result: state.result,
          selection: state.filterSelection,
        )) {
      return [const EmptyState(message: 'No results found')];
    }

    if (state.result == null) {
      return [const HRestaurantCardShimmer(count: 6)];
    }

    return [
      SearchResultsView(
        query: state.query,
        categories: state.result!.categories,
        restaurants: SearchResultFilter.restaurants(
          restaurants: state.result!.restaurants,
          sort: state.sort,
          rating4Plus: state.rating4Plus,
        ),
        items: SearchResultFilter.items(
          items: state.result!.items,
          sort: state.sort,
          priceRange: state.priceRange,
          dietary: state.dietary,
          under300: state.under300,
        ),
        onCategoryTap: _onCategoryTap,
      ),
    ];
  }
}
