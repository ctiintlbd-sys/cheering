import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/features/community/presentation/screens/community_screen.dart';
import 'package:cheering/features/food/presentation/blocs/home_feed/home_feed_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/home_feed/home_feed_event.dart';
import 'package:cheering/features/food/presentation/screens/food_screen.dart';
import 'package:cheering/features/orders/domain/entities/get_orders_params.dart';
import 'package:cheering/features/orders/presentation/blocs/order_list/order_list_bloc.dart';
import 'package:cheering/features/orders/presentation/blocs/order_list/order_list_event.dart';
import 'package:cheering/features/orders/presentation/screens/order_screen.dart';
import 'package:cheering/features/profile/presentation/screens/profile_screen.dart';
import 'package:cheering/features/store/presentation/screens/store_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/bottom_nav_bar/presentation/screens/bottom_nav_screen.dart';
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
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<HomeFeedBloc>()..add(const LoadHomeFeed()),
              child: const FoodScreen(),
            ),
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
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<OrderListBloc>()
                ..add(const LoadOrders(params: GetOrdersParams())),
              child: const OrderScreen(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.communityTab,
            builder: (context, state) => const CommunityScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.profileTab,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  ),
];
