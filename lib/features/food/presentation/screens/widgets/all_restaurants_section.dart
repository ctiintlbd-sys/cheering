import 'package:cheering/features/food/presentation/screens/widgets/h_restaurant_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_state.dart';

class AllRestaurantsSection extends StatelessWidget {
  const AllRestaurantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantListBloc, RestaurantListState>(
      builder: (context, state) {
        if (state.restaurants.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionHeaderWidget(
              title: 'All Restaurants',
            ).horizontal(16.w),
            SizedBox(height: 8.w),
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
            SizedBox(height: 20.w),
          ],
        );
      },
    );
  }
}
