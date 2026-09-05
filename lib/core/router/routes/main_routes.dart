import 'package:cheering/features/food/presentation/screens/food_screen.dart';
import 'package:cheering/features/store/presentation/screens/store_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../features/bottom_nav_bar/presentation/screens/bottom_nav_screen.dart';
import '../../../features/overview/presentation/screens/overview_screen.dart';
import '../route_paths.dart';

final List<RouteBase> mainRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return BottomNavScreen(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.foodTab,
            builder: (context, state) => const FoodScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.storeTab,
            builder: (context, state) => const StoreScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.ordersTab,
            builder: (context, state) => const OverviewScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.communityTab,
            builder: (context, state) => const OverviewScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.profileTab,
            builder: (context, state) => const OverviewScreen(),
          ),
        ],
      ),
    ],
  ),
];
