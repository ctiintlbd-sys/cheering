import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_paths.dart';
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
            appBar: CustomSliverAppBar(
              title: 'My Favorites',
              pinned: true,
              backgroundColor: context.colors.background,
            ),
            bodyList: switch (state.status) {
              FavoritesStatus.initial ||
              FavoritesStatus.loading => [const FavoritesGridShimmer(count: 6)],
              FavoritesStatus.failure => [
                EmptyState(
                  icon: Assets.images.fevEmpty.image(width: 76.w, height: 76.w),
                  message: state.errorMessage ?? 'Failed to load favorites',
                ),
              ],

              FavoritesStatus.success when state.favorites.isNotEmpty => [
                EmptyState(
                  icon: Assets.images.fevEmpty.image(width: 76.w, height: 76.w),
                  message: 'Your Favorite is empty',
                  subMessage:
                      'You haven\'t added anything to your favorite yet',
                  buttonText: 'Start Explore',
                  onPressed: () => context.go(RoutePaths.foodTab),
                ),
              ],

              FavoritesStatus.success => [
                SizedBox(height: 16.w),
                GridView.builder(
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
                ).horizontal(16.w),
                SizedBox(height: 120.w),
              ],
            },
          );
        },
      ),
    );
  }
}
