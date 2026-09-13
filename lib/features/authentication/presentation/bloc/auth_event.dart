import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when user enters email to request registration OTP
class SendOtpRequested extends AuthEvent {
  final String email;
  final String role;

  const SendOtpRequested({
    required this.email,
    this.role = 'CUSTOMER',
  });

  @override
  List<Object?> get props => [email, role];
}

/// Triggered in AboutScreen when completing account creation
class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String code;
  final String password;
  final String fullName;

  const VerifyOtpRequested({
    required this.email,
    required this.code,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, code, password, fullName];
}

/// Triggered in PasswordScreen when logging in with email and password
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Triggered when user taps "Continue with Google"
class GoogleLoginRequested extends AuthEvent {
  const GoogleLoginRequested();
}

/// Triggered in ForgotScreen to request reset code
class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Triggered in ResetPasswordScreen to submit new password
class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, code, newPassword];
}

/// Triggered when user logs out of their account
class LogoutRequested extends AuthEvent {
  final String? refreshToken;
  final bool allDevices;

  const LogoutRequested({
    this.refreshToken,
    this.allDevices = false,
  });

  @override
  List<Object?> get props => [refreshToken, allDevices];
}

/// Triggered when toggling between Sign In and Sign Up mode
class ToggleAuthMode extends AuthEvent {
  const ToggleAuthMode();
}

/// Explicitly set the auth mode (Sign In vs Sign Up)
class SetAuthMode extends AuthEvent {
  final bool isSignUp;

  const SetAuthMode({required this.isSignUp});

  @override
  List<Object?> get props => [isSignUp];
}

/// Resets error and status state back to initial
class ResetAuthStatus extends AuthEvent {
  const ResetAuthStatus();
}
