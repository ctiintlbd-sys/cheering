import 'package:cheering/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:cheering/features/address/presentation/screens/address_screen.dart';
import 'package:cheering/features/address/presentation/screens/manual_address_map_screen.dart';
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
  ),
  GoRoute(
    path: RoutePaths.manualAddressMap,
    builder: (context, state) => const ManualAddressMapScreen(),
  ),
];
