import 'package:cheering/features/authentication/presentation/screen/about_screen.dart';
import 'package:cheering/features/authentication/presentation/screen/enable_biometrics_screen.dart';
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
    builder: (context, state) {
      final email = (state.extra as String?) ?? '';
      return PasswordScreen(email: email);
    },
  ),

  GoRoute(
    path: RoutePaths.otp,
    builder: (context, state) {
      if (state.extra is Map<String, dynamic>) {
        final args = state.extra as Map<String, dynamic>;
        return OtpScreen(
          email: args['email'] as String? ?? '',
          isForgotPassword: args['isForgotPassword'] as bool? ?? false,
        );
      }
      return OtpScreen(
        email: (state.extra as String?) ?? '',
        isForgotPassword: false,
      );
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
    path: RoutePaths.about,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>;
      return AboutScreen(
        email: args['email'] as String,
        otp: args['otp'] as String,
        password: args['password'] as String,
      );
    },
  ),

  GoRoute(
    path: RoutePaths.enableBiometrics,
    builder: (context, state) => const EnableBiometricsScreen(),
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
