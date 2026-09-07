import 'package:cheering/features/food/presentation/screens/category_details_screen.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

final List<RouteBase> foodRoutes = [
  GoRoute(
    path: RoutePaths.categoryDetails,
    builder: (context, state) => const CategoryDetailsScreen(
      categoryName: 'Pizza',
    ),
  ),
];
