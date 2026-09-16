import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../di/service_locator.dart';
import 'app_router.dart';
import 'app_router_notifier.dart';
import 'route_paths.dart';

/// Preserves `?redirect=` across auth screens and after login (via [AppAuthGuard]).
abstract final class AuthRedirect {
  static const queryKey = 'redirect';

  static String? fromState(GoRouterState state) =>
      state.uri.queryParameters[queryKey];

  static String? fromContext(BuildContext context) =>
      fromState(GoRouterState.of(context));

  /// Current location redirect (safe outside [RouteBase.builder], e.g. app root listener).
  static String? fromActiveRoute() => fromRouter(AppRouter.router);

  static String? fromRouter(GoRouter router) =>
      router.state.uri.queryParameters[queryKey];

  static String loginPath({required String returnTo}) =>
      '${RoutePaths.login}?$queryKey=${Uri.encodeComponent(returnTo)}';

  static String withRedirect(String path, {String? redirect}) {
    if (redirect == null || redirect.isEmpty) return path;
    final separator = path.contains('?') ? '&' : '?';
    return '$path$separator$queryKey=${Uri.encodeComponent(redirect)}';
  }

  static String withRedirectFromContext(BuildContext context, String path) =>
      withRedirect(path, redirect: fromContext(context));

  /// After login or sign-up completes: optional biometrics, then `?redirect=` or home.
  ///
  /// Uses [AppRouter.router] so it works from [MaterialApp.router]'s builder (no
  /// [GoRouterState] in that subtree).
  static void goAfterSignIn() {
    final router = AppRouter.router;
    final notifier = getIt<AppRouterNotifier>();
    final redirect = fromRouter(router);

    if (notifier.pendingBiometricOffer) {
      router.go(
        withRedirect(RoutePaths.enableBiometrics, redirect: redirect),
      );
      return;
    }

    if (redirect != null && redirect.isNotEmpty) {
      router.go(Uri.decodeComponent(redirect));
      return;
    }

    router.go(RoutePaths.foodTab);
  }
}
