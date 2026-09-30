import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:cheering/features/orders/presentation/blocs/order_details/order_details_bloc.dart';
import 'package:cheering/features/orders/presentation/blocs/order_details/order_details_event.dart';
import 'package:cheering/features/orders/presentation/blocs/rate_order/rate_order_bloc.dart';
import 'package:cheering/features/orders/presentation/screens/order_details_screen.dart';
import 'package:cheering/features/orders/presentation/screens/rate_order_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> orderRoutes = [
  GoRoute(
    path: RoutePaths.orderDetails,
    builder: (context, state) {
      final orderId = state.pathParameters['id'] ?? '';
      return BlocProvider(
        create: (_) =>
            getIt<OrderDetailsBloc>()..add(LoadOrderDetails(orderId: orderId)),
        child: const OrderDetailsScreen(),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.rateOrder,
    builder: (context, state) {
      final order = state.extra as OrderEntity;
      return BlocProvider(
        create: (_) => getIt<RateOrderBloc>(),
        child: RateOrderScreen(order: order),
      );
    },
  ),
];

