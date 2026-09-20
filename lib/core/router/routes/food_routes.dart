import 'package:cheering/features/food/presentation/screens/explore_restaurants_screen.dart';
import 'package:cheering/features/food/presentation/screens/restaurant_details_screen.dart';
import 'package:cheering/features/food/presentation/screens/item_details_screen.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_event.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_list/restaurant_list_event.dart';
import 'package:cheering/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/features/cart/presentation/screens/cart_screen.dart';
import '../route_paths.dart';

final List<RouteBase> foodRoutes = [
  GoRoute(
    path: RoutePaths.restaurantList,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      final title = extra['title'] as String;
      final params = extra['params'] as RestaurantQueryParams;

      return BlocProvider(
        create: (context) => getIt<RestaurantListBloc>()..add(LoadRestaurants(params: params)),
        child: ExploreRestaurantsScreen(title: title, initialParams: params),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.storeDetails,
    builder: (context, state) {
      final restaurant = state.extra as RestaurantEntity;
      return BlocProvider(
        create: (context) =>
            getIt<RestaurantDetailsBloc>()
              ..add(LoadRestaurantDetails(restaurant: restaurant)),
        child: const RestaurantDetailsScreen(),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.itemDetails,
    builder: (context, state) => const ItemDetailsScreen(),
  ),
  GoRoute(
    path: RoutePaths.cart,
    builder: (context, state) => const CartScreen(),
  ),
];
