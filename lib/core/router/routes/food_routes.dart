import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';

import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/food/presentation/screens/explore_restaurants_screen.dart';
import 'package:cheering/features/food/presentation/screens/restaurant_details_screen.dart';
import 'package:cheering/features/food/presentation/screens/item_details_screen.dart';
import 'package:cheering/features/food/presentation/screens/reels_viewer_screen.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_event.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_event.dart';
import 'package:cheering/features/food/presentation/blocs/item_details/item_details_bloc.dart';
import 'package:cheering/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:cheering/features/favorites/presentation/blocs/favorites_bloc.dart';
import 'package:cheering/features/favorites/presentation/blocs/favorites_event.dart';
import 'package:cheering/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';
import '../route_args.dart';

final List<RouteBase> foodRoutes = [
  GoRoute(
    path: RoutePaths.reelsViewer,
    builder: (context, state) {
      final args = state.extra as ReelsViewerArgs;
      return ReelsViewerScreen(
        reels: args.reels,
        initialIndex: args.initialIndex,
      );
    },
  ),
  GoRoute(
    path: RoutePaths.restaurantList,
    builder: (context, state) {
      final args = state.extra as RestaurantListArgs;
      return BlocProvider(
        create: (context) =>
            getIt<RestaurantListBloc>()
              ..add(LoadRestaurants(params: args.params)),
        child: ExploreRestaurantsScreen(
          title: args.title,
          initialParams: args.params,
        ),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.storeDetailsRoute,
    builder: (context, state) {
      final id = state.pathParameters['id'];
      final extra = state.extra;
      final restaurant = extra is RestaurantEntity ? extra : null;
      return BlocProvider(
        create: (context) =>
            getIt<RestaurantDetailsBloc>()
              ..add(LoadRestaurantDetails(id: id, restaurant: restaurant)),
        child: const RestaurantDetailsScreen(),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.itemDetails,
    builder: (context, state) {
      final item = state.extra as MenuItemEntity;
      final cartItem = context
          .read<CartBloc>()
          .state
          .cart
          ?.items
          .where((i) => i.menuItemId == item.id)
          .firstOrNull;

      return BlocProvider(
        create: (context) => ItemDetailsBloc(item, cartItem: cartItem),
        child: ItemDetailsScreen(menuItem: item),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.favorites,
    builder: (context, state) {
      context.read<FavoritesBloc>().add(const LoadFavorites());
      return const FavoritesScreen();
    },
  ),
];
