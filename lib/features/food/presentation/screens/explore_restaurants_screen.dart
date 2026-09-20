import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_event.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_state.dart';
import 'package:cheering/features/food/presentation/screens/widgets/h_restaurant_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cheering/features/food/presentation/screens/widgets/restaurant_filters_bar.dart';
import 'package:cheering/features/food/presentation/models/filter_data.dart';

class ExploreRestaurantsScreen extends StatelessWidget {
  final String title;
  final RestaurantQueryParams initialParams;

  const ExploreRestaurantsScreen({
    super.key,
    required this.title,
    required this.initialParams,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantListBloc, RestaurantListState>(
      builder: (context, state) {
        return SliverScaffold(
          onRefresh: ()async{
          },
          appBar: CustomSliverAppBar(
            title: title,
            expandedHeight: 104.w,
            flexibleChild: const SizedBox.shrink(),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(28.w),
              child: RestaurantFiltersBar(
                filters: FilterData.filters,
                selectedIndex: state.selectedFilterIndex,
                onFilterChanged: (index, filterParams) {
                  context.read<RestaurantListBloc>().add(
                    ApplyRestaurantFilter(
                      index: index,
                      filterParams: filterParams,
                    ),
                  );
                },
              ),
            ),
          ),
          bodyList: [
            if (state.status == RestaurantListStatus.initial ||
                state.status == RestaurantListStatus.loading)
              Padding(
                padding: EdgeInsets.only(top: 24.w),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (state.status == RestaurantListStatus.failure)
              Padding(
                padding: EdgeInsets.only(top: 26.w),
                child: EmptyState(
                  message: state.errorMessage ?? 'Failed to load',
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.w),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.restaurants.length,
                    separatorBuilder: (context, index) => SizedBox(height: 4.w),
                    itemBuilder: (context, index) {
                      return CustomItemAnimator(
                        index: index,
                        animationType: CustomItemAnimationType.slide,
                        child: HRestaurantCardWidget(
                          restaurant: state.restaurants[index],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 120.w),
                ],
              ),
          ],
        );
      },
    );
  }
}
