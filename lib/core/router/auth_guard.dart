import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router_notifier.dart';
import 'route_paths.dart';

abstract final class AppAuthGuard {
  // ── Protected routes (login required) ────────────────────────────────────
  static const _protectedRoutes = {
    RoutePaths.accountSettings,
    RoutePaths.cart,
    // RoutePaths.orderHistory,
    // RoutePaths.savedAddresses,
  };

  // ── Guest-only routes ─────────────────────────
  static const _guestOnlyRoutes = {
    RoutePaths.login,
    RoutePaths.password,
    RoutePaths.forgotPassword,
    RoutePaths.setPassword,
    RoutePaths.about,
    RoutePaths.onboarding,
  };

  static bool _isProtectedRoute(String location) =>
      _protectedRoutes.contains(location);

  static bool _isGuestOnlyRoute(String location) =>
      _guestOnlyRoutes.contains(location) || location.startsWith('/otp');

  static String? redirect(
    BuildContext context,
    GoRouterState state,
    AppRouterNotifier notifier,
  ) {
    final isAuth = notifier.isAuthenticated;
    final isInit = notifier.isInitialized;
    final location = state.uri.path;

    if (!isInit) {
      return location == RoutePaths.splash ? null : RoutePaths.splash;
    }

    if (location == RoutePaths.splash) {
      return notifier.isOnboardingSeen
          ? RoutePaths.foodTab
          : RoutePaths.onboarding;
    }
    if (location == RoutePaths.onboarding && notifier.isOnboardingSeen) {
      return RoutePaths.foodTab;
    }

    if (!isAuth && _isProtectedRoute(location)) {
      final encoded = Uri.encodeComponent(state.uri.toString());
      return '${RoutePaths.login}?redirect=$encoded';
    }
    if (isAuth && _isGuestOnlyRoute(location)) {
      if (notifier.pendingBiometricOffer) {
        return _enableBiometricsLocation(state);
      }

      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        return Uri.decodeComponent(redirect);
      }
      return RoutePaths.foodTab;
    }
    return null;
  }

  static String _enableBiometricsLocation(GoRouterState state) {
    final redirect = state.uri.queryParameters['redirect'];
    if (redirect != null && redirect.isNotEmpty) {
      return '${RoutePaths.enableBiometrics}?redirect=${Uri.encodeComponent(redirect)}';
    }
    return RoutePaths.enableBiometrics;
  }
}
