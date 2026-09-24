import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_event.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_bloc.dart';
import 'package:cheering/features/cart/presentation/screens/cart_screen.dart';
import 'package:cheering/features/cart/presentation/screens/checkout_screen.dart';
import '../route_paths.dart';

final List<RouteBase> cartRoutes = [
  GoRoute(
    path: RoutePaths.cart,
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: RoutePaths.checkout,
    builder: (context, state) => BlocProvider(
      create: (context) => getIt<CheckoutSummaryBloc>(),
      child: const CheckoutScreen(),
    ),
  ),
];
