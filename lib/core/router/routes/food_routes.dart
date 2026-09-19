import 'package:cheering/features/food/presentation/screens/category_details_screen.dart';
import 'package:cheering/features/food/presentation/screens/restaurant_details_screen.dart';
import 'package:cheering/features/food/presentation/screens/item_details_screen.dart';
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
    builder: (context, state) => const RestaurantDetailsScreen(),
  ),
  GoRoute(
    path: RoutePaths.itemDetails,
    builder: (context, state) => const ItemDetailsScreen(),
  ),
];
