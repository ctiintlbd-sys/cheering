import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_event.dart';
import 'package:cheering/features/address/presentation/screens/add_address_screen.dart';
import 'package:cheering/features/address/presentation/screens/manual_address_map_screen.dart';
import 'package:cheering/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:cheering/features/address/presentation/screens/address_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

final List<RouteBase> profileRoutes = [
  GoRoute(
    path: RoutePaths.accountSettings,
    builder: (context, state) => const AccountSettingsScreen(),
  ),
  GoRoute(
    path: RoutePaths.address,
    builder: (context, state) => const AddressScreen(),
    routes: [
      GoRoute(
        path: 'manual-map',
        builder: (context, state) => const ManualAddressMapScreen(),
      ),
      GoRoute(
        path: 'add',
        builder: (context, state) {
          final args = state.extra as AddressEntity;
          return AddAddressScreen(args: args);
        },
      ),
    ],
  ),
];
