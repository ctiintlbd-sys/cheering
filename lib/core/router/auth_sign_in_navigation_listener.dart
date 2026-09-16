import 'package:cheering/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:cheering/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_redirect.dart';

/// Navigates after auth completes: sign-in, sign-up (OTP verify), same `?redirect=` rules.
class AuthSignInNavigationListener extends StatelessWidget {
  const AuthSignInNavigationListener({super.key, required this.child});

  final Widget child;

  static const _completedAuthActions = {
    AuthAction.login,
    AuthAction.googleLogin,
    AuthAction.biometricLogin,
    AuthAction.verifyOtp,
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current.status == AuthStatus.success &&
          _completedAuthActions.contains(current.action) &&
          (previous.status != AuthStatus.success ||
              previous.action != current.action),
      listener: (context, state) => AuthRedirect.goAfterSignIn(),
      child: child,
    );
  }
}
