import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_event.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_state.dart';
import 'package:cheering/features/food/presentation/screens/widgets/h_restaurant_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantListScreen extends StatefulWidget {
  final String title;
  final RestaurantQueryParams initialParams;

  const RestaurantListScreen({
    super.key,
    required this.title,
    required this.initialParams,
  });

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  late RestaurantQueryParams _currentParams;

  @override
  void initState() {
    super.initState();
    _currentParams = widget.initialParams;
  }

  void _updateParams(RestaurantQueryParams newParams) {
    setState(() {
      _currentParams = newParams;
    });
    context.read<RestaurantListBloc>().add(RefreshRestaurants(params: newParams));
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      //sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        title: widget.title,
        expandedHeight: 96.w,
        flexibleChild: const SizedBox.shrink(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(28.w),
          child: SizedBox(
            height: 40.w,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final isSelected = index == 0; // Dummy filter state
                final filters = ['Sort', 'Rating', 'Offers', 'Price'];
                return CustomFilterChip(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.w,
                  ),
                  label: filters[index],
                  labelSize: 14.r,
                  isSelected: isSelected,
                  onTap: () {
                    // TODO: Implement actual filter logic here
                  },
                );
              },
            ),
          ),
        ),
      ),
      bodyList: [
        BlocBuilder<RestaurantListBloc, RestaurantListState>(
          builder: (context, state) {
            if (state.status == RestaurantListStatus.initial ||
                state.status == RestaurantListStatus.loading) {
              return Padding(
                padding: EdgeInsets.only(top: 26.w),
                child: const Center(child: CircularProgressIndicator()), // TODO: Add Shimmer here later
              );
            }

            if (state.status == RestaurantListStatus.failure) {
              return Padding(
                padding: EdgeInsets.only(top: 26.w),
                child: EmptyState(message: state.errorMessage ?? 'Failed to load'),
              );
            }

            final restaurants = state.restaurants;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 26.w),

                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: restaurants.length,
                  separatorBuilder: (context, index) => SizedBox(height: 4.w),
                  itemBuilder: (context, index) {
                    return CustomItemAnimator(
                      index: index,
                      animationType: CustomItemAnimationType.slide,
                      child:  HRestaurantCardWidget(restaurant: restaurants[index]),
                    );
                  },
                ),
                SizedBox(height: 120.w),
              ],
            );
          },
        ),
      ],
    );
  }
}
