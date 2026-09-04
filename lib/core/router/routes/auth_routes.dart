import 'package:cheering/features/authentication/presentation/screen/otp_screen.dart';
import 'package:cheering/features/authentication/presentation/screen/password_screen.dart';
import 'package:cheering/features/authentication/presentation/screen/set_password_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../features/authentication/presentation/screen/forgot_screen.dart';
import '../../../features/authentication/presentation/screen/email_screen.dart';
import '../../../features/authentication/presentation/screen/reset_password_screen.dart';
import '../route_paths.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: RoutePaths.login,
    builder: (context, state) => const EmailScreen(),
  ),
  GoRoute(
    path: RoutePaths.forgotPassword,
    builder: (context, state) => const ForgotScreen(),
  ),

  GoRoute(
    path: RoutePaths.password,
    builder: (context, state) => const PasswordScreen(),
  ),

  GoRoute(
    path: RoutePaths.otp,
    builder: (context, state) {
      return OtpScreen(email: state.extra as String);
    },
  ),

  GoRoute(
    path: RoutePaths.setPassword,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>;
      return SetPasswordScreen(
        email: args['email'] as String,
        otp: args['otp'] as String,
      );
    },
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
