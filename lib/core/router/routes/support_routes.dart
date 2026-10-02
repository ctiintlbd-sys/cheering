import 'package:cheering/features/support/presentation/screens/support_screen.dart';
import 'package:go_router/go_router.dart';

import '../route_paths.dart';

final List<RouteBase> supportRoutes = [
  GoRoute(
    path: RoutePaths.helpCenter,
    builder: (context, state) => const SupportScreen(),
  ),
];
