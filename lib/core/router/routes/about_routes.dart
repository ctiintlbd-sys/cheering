import 'package:cheering/features/about_as/presentation/screens/about_as_screen.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

final List<RouteBase> aboutRoutes = [
  GoRoute(
    path: RoutePaths.aboutAs,
    builder: (context, state) => const AboutUsScreen(),
  ),
];
