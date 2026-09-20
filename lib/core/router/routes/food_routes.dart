import 'package:cheering/features/food/presentation/screens/category_details_screen.dart';
import 'package:cheering/features/food/presentation/screens/restaurant_details_screen.dart';
import 'package:cheering/features/food/presentation/screens/item_details_screen.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_event.dart';
import 'package:cheering/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

final List<RouteBase> foodRoutes = [
  GoRoute(
    path: RoutePaths.categoryDetails,
    builder: (context, state) =>
        const CategoryDetailsScreen(categoryName: 'Pizza'),
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
];
