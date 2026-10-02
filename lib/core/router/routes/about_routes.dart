import 'package:cheering/features/about_as/presentation/screens/about_as_screen.dart';
import 'package:cheering/features/about_as/presentation/screens/our_story_screen.dart';
import 'package:cheering/features/about_as/presentation/screens/privacy_screen.dart';
import 'package:cheering/features/about_as/presentation/screens/terms_screen.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

final List<RouteBase> aboutRoutes = [
  GoRoute(
    path: RoutePaths.aboutAs,
    builder: (context, state) => const AboutUsScreen(),
  ),
  GoRoute(
    path: RoutePaths.ourStory,
    builder: (context, state) => const OurStoryScreen(),
  ),

  GoRoute(path: RoutePaths.privacy, builder: (context, state) => const PrivacyScreen()),
  GoRoute(path: RoutePaths.terms, builder: (context, state) => const TermsScreen()),
];
