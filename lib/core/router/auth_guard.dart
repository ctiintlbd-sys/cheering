import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router_notifier.dart';
import 'route_paths.dart';

abstract final class AppAuthGuard {
  /// Routes that are only meant for unauthenticated guests (Login, Signup, OTP, Password Reset, Onboarding).
  static const _authRoutes = {
    RoutePaths.login,
    RoutePaths.password,
    RoutePaths.setPassword,
    RoutePaths.about,
    RoutePaths.enableBiometrics,
    RoutePaths.forgotPassword,
    RoutePaths.resetPassword,
    RoutePaths.onboarding,
  };

  static bool _isAuthRoute(String location) =>
      _authRoutes.contains(location) || location.startsWith('/otp');

  static String? redirect(
    BuildContext context,
    GoRouterState state,
    AppRouterNotifier notifier,
  ) {
    final isAuth = notifier.isAuthenticated;
    final isInit = notifier.isInitialized;
    final location = state.uri.path;

    // ── 1. Splash redirect ─────────────────────────────────────────────────
    if (!isInit) {
      return location == RoutePaths.splash ? null : RoutePaths.splash;
    }

    if (location == RoutePaths.splash) {
      if (!isAuth) {
        // Jodi first install / onboarding dekha na hoye thake -> Onboarding
        // Jodi agei onboarding dekha hoye thake -> Login
        return notifier.isOnboardingSeen
            ? RoutePaths.login
            : RoutePaths.onboarding;
      }
      return RoutePaths.foodTab;
    }

    // ── 2. Unauthenticated user on onboarding route but already completed it
    if (!isAuth &&
        location == RoutePaths.onboarding &&
        notifier.isOnboardingSeen) {
      return RoutePaths.login;
    }

    // ── 3. Unauthenticated user trying to access a protected route ─────────
    if (!isAuth && !_isAuthRoute(location)) {
      final targetUri = Uri.encodeComponent(state.uri.toString());
      return '${RoutePaths.login}?redirect=$targetUri';
    }

    // ── 4. Authenticated user trying to access an auth/guest route ─────────
    if (isAuth && _isAuthRoute(location)) {
      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        return Uri.decodeComponent(redirect);
      }
      return RoutePaths.foodTab;
    }

    // ── 5. Allow navigation ────────────────────────────────────────────────
    return null;
  }
}
