import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:cheering/features/chat/presentation/bloc/chat_event.dart';
import 'package:cheering/features/chat/presentation/screens/rider_chat_screen.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:cheering/features/tracking/presentation/blocs/order_tracking/order_tracking_bloc.dart';
import 'package:cheering/features/tracking/presentation/blocs/order_tracking/order_tracking_event.dart';
import 'package:cheering/features/tracking/presentation/screens/order_tracking_map_screen.dart';
import 'package:cheering/features/tracking/presentation/screens/order_tracking_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> trackingRoutes = [
  GoRoute(
    path: RoutePaths.orderTracking,
    builder: (context, state) {
      final orderId = state.pathParameters['id'] ?? '';
      return BlocProvider(
        create: (_) =>
            getIt<OrderTrackingBloc>()..add(LoadOrderTracking(orderId)),
        child: const OrderTrackingScreen(),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.orderTrackingMap,
    builder: (context, state) {
      final tracking = state.extra as OrderTrackingEntity;
      return OrderTrackingMapScreen(tracking: tracking);
    },
  ),
  GoRoute(
    path: RoutePaths.riderChat,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      final extra = state.extra;
      final tracking = extra is OrderTrackingEntity ? extra : null;

      return BlocProvider(
        create: (context) => getIt<ChatBloc>()
          ..add(LoadChatThread(orderId: id, tracking: tracking)),
        child: const RiderChatScreen(),
      );
    },
  ),
];
