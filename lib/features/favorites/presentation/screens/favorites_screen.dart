import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/restaurant_card_widget.dart';
import '../blocs/favorites_bloc.dart';
import '../blocs/favorites_event.dart';
import '../blocs/favorites_state.dart';
import 'widgets/favorites_grid_shimmer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listenWhen: (previous, current) =>
          current.actionErrorMessage != null &&
          current.actionErrorMessage != previous.actionErrorMessage,
      listener: (context, state) {
        if (state.actionErrorMessage != null) {
          ToastMessageHelper.show(state.actionErrorMessage!);
          context.read<FavoritesBloc>().add(const ClearFavoritesActionError());
        }
      },
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          return SliverScaffold(
            onRefresh: () async {
              context.read<FavoritesBloc>().add(const RefreshFavorites());
            },
            appBar: const CustomSliverAppBar(
              title: 'My Favorites',
              showLeading: true,
              pinned: true,
            ),
            bodyList: switch (state.status) {
              FavoritesStatus.initial || FavoritesStatus.loading
                  when state.favorites.isEmpty =>
                [const FavoritesGridShimmer(count: 6)],
              FavoritesStatus.failure when state.favorites.isEmpty => [
                EmptyState(
                  message: state.errorMessage ?? 'Failed to load favorites',
                ),
              ],
              _ when state.favorites.isEmpty => [
                const EmptyState(message: 'No favorite restaurants yet'),
              ],
              _ => [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.w,
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.w,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 174 / 200,
                    ),
                    itemCount: state.favorites.length,
                    itemBuilder: (context, index) {
                      final restaurant = state.favorites[index];
                      return CustomItemAnimator(
                        index: index,
                        animationType: CustomItemAnimationType.slide,
                        child: RestaurantCardWidget(
                          restaurant: restaurant,
                          isFavorite: state.isFavorite(restaurant.id),
                          onFavoriteTap: () {
                            context.read<FavoritesBloc>().add(
                              ToggleFavoriteRestaurant(
                                restaurant.id,
                                restaurant: restaurant,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 100.w),
              ],
            },
          );
        },
      ),
    );
  }
}
