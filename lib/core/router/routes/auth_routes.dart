import 'package:cheering/features/authentication/presentation/screen/about_screen.dart';
import 'package:cheering/features/authentication/presentation/screen/enable_biometrics_screen.dart';
import 'package:cheering/features/authentication/presentation/screen/otp_screen.dart';
import 'package:cheering/features/authentication/presentation/screen/password_screen.dart';
import 'package:cheering/features/authentication/presentation/screen/set_password_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../features/authentication/presentation/screen/forgot_screen.dart';
import '../../../features/authentication/presentation/screen/email_screen.dart';
import '../route_paths.dart';

import '../route_args.dart';

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
      if (state.extra is OtpScreenArgs) {
        final args = state.extra as OtpScreenArgs;
        return OtpScreen(
          email: args.email,
          isForgotPassword: args.isForgotPassword,
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
      final args = state.extra as SetPasswordScreenArgs;
      return SetPasswordScreen(
        email: args.email,
        otp: args.otp,
        isForgotPassword: args.isForgotPassword,
      );
    },
  ),

  GoRoute(
    path: RoutePaths.about,
    builder: (context, state) {
      final args = state.extra as AboutScreenArgs;
      return AboutScreen(
        email: args.email,
        otp: args.otp,
        password: args.password,
      );
    },
  ),

  GoRoute(
    path: RoutePaths.enableBiometrics,
    builder: (context, state) => const EnableBiometricsScreen(),
  ),
];
