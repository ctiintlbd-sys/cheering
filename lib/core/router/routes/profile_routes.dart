import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:cheering/features/address/presentation/bloc/address_form_cubit.dart';
import 'package:cheering/features/address/presentation/bloc/map_picker_cubit.dart';
import 'package:cheering/features/address/presentation/screens/add_address_screen.dart';
import 'package:cheering/features/address/presentation/screens/address_screen.dart';
import 'package:cheering/features/address/presentation/screens/manual_address_map_screen.dart';
import 'package:cheering/features/profile/presentation/screens/account_settings_screen.dart';
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
        builder: (context, state) {
          final autoFocusSearch = state.extra as bool? ?? false;
          return BlocProvider(
            create: (_) => MapPickerCubit(),
            child: ManualAddressMapScreen(autoFocusSearch: autoFocusSearch),
          );
        },
      ),
      GoRoute(
        path: 'add',
        builder: (context, state) {
          final args = state.extra as AddressEntity;
          return BlocProvider(
            create: (_) => AddressFormCubit(args),
            child: AddAddressScreen(args: args),
          );
        },
      ),
    ],
  ),
];
