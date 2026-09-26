import 'package:cheering/core/router/routes/main_routes.dart';
import 'package:cheering/core/router/routes/profile_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/splash/presentation/bloc/onboarding_bloc.dart';
import '../../../features/splash/presentation/screens/onboarding_screen.dart';
import '../../../features/splash/presentation/screens/splash_screen.dart';
import '../di/service_locator.dart';
import 'app_router_notifier.dart';
import 'auth_guard.dart';
import 'route_paths.dart';
import 'routes/auth_routes.dart';
import 'routes/food_routes.dart';
import 'routes/cart_routes.dart';
import 'routes/tracking_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: getIt<AppRouterNotifier>(),
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) =>
        AppAuthGuard.redirect(context, state, getIt<AppRouterNotifier>()),
    routes: [
      // ── 1. Splash & Onboarding ───────────────────────────────────────────
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => BlocProvider(
          create: (context) => OnboardingBloc(),
          child: const OnboardingScreen(),
        ),
      ),

      // ── 2. Auth Flow ─────────────────────────────────────────────────────
      ...authRoutes,
      ...mainRoutes,
      ...foodRoutes,
      ...cartRoutes,
      ...trackingRoutes,
      ...profileRoutes,
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Page not found: ${state.error}'),
        ),
      ),
    ),
  );
}
