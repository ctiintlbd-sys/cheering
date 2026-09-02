import 'package:go_router/go_router.dart';

import '../../../features/authentication/presentation/screen/forgot_screen.dart';
import '../../../features/authentication/presentation/screen/login_screen.dart';
import '../../../features/authentication/presentation/screen/reset_password_screen.dart';
import '../route_paths.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: RoutePaths.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: RoutePaths.forgotPassword,
    builder: (context, state) => const ForgotScreen(),
  ),
  GoRoute(
    path: RoutePaths.resetPassword,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>;
      return ResetPasswordScreen(
        email: args['email'] as String,
        code: args['code'] as String,
      );
    },
  ),
];
