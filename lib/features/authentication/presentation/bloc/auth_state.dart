import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/entities/login_result_entity.dart';
import '../../domain/entities/reset_password_result_entity.dart';

enum AuthStatus { initial, loading, success, failure }

enum AuthAction {
  none,
  sendOtp,
  verifyOtp,
  login,
  googleLogin,
  forgotPassword,
  resetPassword,
  logout,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthAction action;
  final bool isSignUp;
  final String? errorMessage;
  final String? successMessage;
  final LoginResultEntity? loginResult;
  final ResetPasswordResultEntity? resetPasswordResult;
  final AuthTokensEntity? googleTokens;

  const AuthState({
    this.status = AuthStatus.initial,
    this.action = AuthAction.none,
    this.isSignUp = false,
    this.errorMessage,
    this.successMessage,
    this.loginResult,
    this.resetPasswordResult,
    this.googleTokens,
  });

  bool get isLoading => status == AuthStatus.loading;

  bool get isSendOtpLoading => isLoading && action == AuthAction.sendOtp;

  bool get isVerifyOtpLoading => isLoading && action == AuthAction.verifyOtp;

  bool get isLoginLoading => isLoading && action == AuthAction.login;

  bool get isGoogleLoading => isLoading && action == AuthAction.googleLogin;

  bool get isForgotPasswordLoading => isLoading && action == AuthAction.forgotPassword;

  bool get isResetPasswordLoading => isLoading && action == AuthAction.resetPassword;

  bool get isLogoutLoading => isLoading && action == AuthAction.logout;

  AuthState copyWith({
    AuthStatus? status,
    AuthAction? action,
    bool? isSignUp,
    String? errorMessage,
    String? successMessage,
    LoginResultEntity? loginResult,
    ResetPasswordResultEntity? resetPasswordResult,
    AuthTokensEntity? googleTokens,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      action: action ?? this.action,
      isSignUp: isSignUp ?? this.isSignUp,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      loginResult: loginResult ?? this.loginResult,
      resetPasswordResult: resetPasswordResult ?? this.resetPasswordResult,
      googleTokens: googleTokens ?? this.googleTokens,
    );
  }

  @override
  List<Object?> get props => [
    status,
    action,
    isSignUp,
    errorMessage,
    successMessage,
    loginResult,
    resetPasswordResult,
    googleTokens,
  ];
}
