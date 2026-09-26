import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/router/route_args.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/cart/domain/entities/checkout_summary_params.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_event.dart';
import 'package:cheering/features/cart/presentation/screens/cart_screen.dart';
import 'package:cheering/features/cart/presentation/screens/checkout_screen.dart';
import 'package:cheering/features/cart/presentation/screens/order_placed_screen.dart';
import 'package:cheering/features/cart/presentation/screens/placing_order_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> cartRoutes = [
  GoRoute(
    path: RoutePaths.cart,
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: RoutePaths.checkout,
    builder: (context, state) {
      final addressId = context.read<AddressBloc>().state.activeDefaultId;
      return BlocProvider(
        create: (context) {
          final bloc = getIt<CheckoutSummaryBloc>();
          if (addressId != null) {
            bloc.add(LoadCheckoutSummary(CheckoutSummaryParams(addressId: addressId)));
          }
          return bloc;
        },
        child: const CheckoutScreen(),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.placingOrder,
    builder: (context, state) {
      final checkoutBloc = state.extra as CheckoutSummaryBloc;
      return BlocProvider.value(
        value: checkoutBloc,
        child: const PlacingOrderScreen(),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.orderPlaced,
    builder: (context, state) => OrderPlacedScreen(
      args: state.extra is OrderPlacedArgs ? state.extra as OrderPlacedArgs : null,
    ),
  ),
];
