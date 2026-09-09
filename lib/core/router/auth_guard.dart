import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router_notifier.dart';
import 'route_paths.dart';

abstract final class AppAuthGuard {
  static const _publicRoutes = {
    RoutePaths.login,
    RoutePaths.password,
    RoutePaths.setPassword,
    RoutePaths.forgotPassword,
    RoutePaths.resetPassword,
    RoutePaths.onboarding,
    RoutePaths.businessInformation,
    RoutePaths.location,
    RoutePaths.ownerInformation,
    RoutePaths.document,
    RoutePaths.payoutMethod,
    RoutePaths.review,
    RoutePaths.applicationSubmitted,
    RoutePaths.foodTab,
    RoutePaths.storeTab,
    RoutePaths.ordersTab,
    RoutePaths.communityTab,
    RoutePaths.profileTab,
    RoutePaths.categoryDetails,
    RoutePaths.storeDetails,
    RoutePaths.itemDetails,
  };

  static bool _isPublicRoute(String location) =>
      _publicRoutes.contains(location) || location.startsWith(RoutePaths.otp);

  static String? redirect(
    BuildContext context,
    GoRouterState state,
    AppRouterNotifier notifier,
  ) {
    final isAuth = notifier.isAuthenticated;
    final isInit = notifier.isInitialized;
    final location = state.uri.path;

    // ── Splash redirect ───────────────────────────────────────────────────
    if (!isInit) {
      return location == RoutePaths.splash ? null : RoutePaths.splash;
    }

    if (location == RoutePaths.splash) {
      if (!isAuth) return RoutePaths.onboarding;
      return RoutePaths.ordersTab;
    }

    // ── Unauthenticated deep link — preserve target URL ───────────────────
    if (!isAuth && !_isPublicRoute(location)) {
      final targetUri = Uri.encodeComponent(state.uri.toString());
      return '${RoutePaths.login}?redirect=$targetUri';
    }

    // ── Authenticated on public route — resume deep link or go home ───────
    if (isAuth && _isPublicRoute(location)) {
      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        return Uri.decodeComponent(redirect);
      }
      return RoutePaths.ordersTab;
    }

    return null;
  }
}
