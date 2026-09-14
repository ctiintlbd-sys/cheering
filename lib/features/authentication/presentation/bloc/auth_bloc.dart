import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router_notifier.dart';
import '../../domain/usecases/enable_biometrics_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/login_with_biometrics_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/skip_biometrics_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final LoginUseCase loginUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LoginWithBiometricsUseCase loginWithBiometricsUseCase;
  final EnableBiometricsUseCase enableBiometricsUseCase;
  final SkipBiometricsUseCase skipBiometricsUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LogoutUseCase logoutUseCase;
  final AppRouterNotifier routerNotifier;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.loginUseCase,
    required this.loginWithGoogleUseCase,
    required this.loginWithBiometricsUseCase,
    required this.enableBiometricsUseCase,
    required this.skipBiometricsUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.logoutUseCase,
    required this.routerNotifier,
  }) : super(const AuthState()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<EnableBiometricsRequested>(_onEnableBiometricsRequested);
    on<SkipBiometricsRequested>(_onSkipBiometricsRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ToggleAuthMode>(_onToggleAuthMode);
    on<SetAuthMode>(_onSetAuthMode);
    on<ResetAuthStatus>(_onResetAuthStatus);
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.sendOtp,
      clearError: true,
    ));

    try {
      final message = await sendOtpUseCase(
        email: event.email,
        role: event.role,
      );
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.sendOtp,
        successMessage: message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.sendOtp,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.verifyOtp,
      clearError: true,
    ));

    try {
      final result = await verifyOtpUseCase(
        email: event.email,
        code: event.code,
        password: event.password,
        fullName: event.fullName,
      );
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.verifyOtp,
        loginResult: result,
        successMessage: 'Account created successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.verifyOtp,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.login,
      clearError: true,
    ));

    try {
      final result = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      routerNotifier.updateAuth(isAuthenticated: true);
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.login,
        loginResult: result,
        successMessage: 'Logged in successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.login,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.googleLogin,
      clearError: true,
    ));

    try {
      final result = await loginWithGoogleUseCase();
      routerNotifier.updateAuth(isAuthenticated: true);
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.googleLogin,
        loginResult: result,
        successMessage: 'Google login successful',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.googleLogin,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.biometricLogin,
      clearError: true,
    ));

    try {
      await loginWithBiometricsUseCase();
      routerNotifier.updateAuth(isAuthenticated: true);
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.biometricLogin,
        successMessage: 'Logged in successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.biometricLogin,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onEnableBiometricsRequested(
    EnableBiometricsRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.enableBiometrics,
      clearError: true,
    ));

    try {
      final enabled = await enableBiometricsUseCase();
      routerNotifier.updateAuth(isAuthenticated: true);
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.enableBiometrics,
        successMessage: enabled
            ? 'Biometric login enabled successfully!'
            : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.enableBiometrics,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSkipBiometricsRequested(
    SkipBiometricsRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.skipBiometrics,
      clearError: true,
    ));

    try {
      await skipBiometricsUseCase();
      routerNotifier.updateAuth(isAuthenticated: true);
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.skipBiometrics,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.skipBiometrics,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.forgotPassword,
      clearError: true,
    ));

    try {
      final message = await forgotPasswordUseCase(email: event.email);
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.forgotPassword,
        successMessage: message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.forgotPassword,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.resetPassword,
      clearError: true,
    ));

    try {
      final result = await resetPasswordUseCase(
        email: event.email,
        code: event.code,
        newPassword: event.newPassword,
      );
      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.resetPassword,
        resetPasswordResult: result,
        successMessage: result.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.resetPassword,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.logout,
      clearError: true,
    ));

    try {
      await logoutUseCase(allDevices: event.allDevices);
      routerNotifier.updateAuth(isAuthenticated: false);
      emit(const AuthState(
        status: AuthStatus.success,
        action: AuthAction.logout,
        successMessage: 'Logged out successfully',
      ));
    } catch (e) {
      routerNotifier.updateAuth(isAuthenticated: false);
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.logout,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onToggleAuthMode(
    ToggleAuthMode event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      isSignUp: !state.isSignUp,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onSetAuthMode(
    SetAuthMode event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      isSignUp: event.isSignUp,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onResetAuthStatus(
    ResetAuthStatus event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      status: AuthStatus.initial,
      action: AuthAction.none,
      clearError: true,
      clearSuccess: true,
    ));
  }
}
