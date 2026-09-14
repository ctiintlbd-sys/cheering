import 'package:cheering/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

final List<RouteBase> profileRoutes = [
  GoRoute(
    path: RoutePaths.accountSettings,
    builder: (context, state) => const AccountSettingsScreen(),
  ),
];
