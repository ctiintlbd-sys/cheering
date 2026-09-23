import 'package:go_router/go_router.dart';
import 'package:cheering/features/cart/presentation/screens/cart_screen.dart';
import '../route_paths.dart';

final List<RouteBase> cartRoutes = [
  GoRoute(
    path: RoutePaths.cart,
    builder: (context, state) => const CartScreen(),
  ),
];
