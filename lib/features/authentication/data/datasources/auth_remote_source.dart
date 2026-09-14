import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/biometric_challenge_model.dart';
import '../models/forgot_password_response_model.dart';
import '../models/login_response_model.dart';
import '../models/reset_password_response_model.dart';
import '../models/send_otp_response_model.dart';

class AuthRemoteSource {
  final IApiClient _client;

  AuthRemoteSource(this._client);

  Future<ApiResult<SendOtpResponseModel>> sendOtp({
    required String email,
    String role = 'CUSTOMER',
  }) {
    return _client.post(
      ApiEndpoints.sendOtp,
      body: {'email': email, 'role': role},
      fromJson: (json) => SendOtpResponseModel.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  Future<ApiResult<LoginResponseModel>> verifyOtp({
    required String email,
    required String code,
    required String password,
    required String fullName,
  }) {
    return _client.post(
      ApiEndpoints.verifyOtp,
      body: {
        'email': email,
        'code': code,
        'password': password,
        'full_name': fullName,
      },
      fromJson: (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  Future<ApiResult<LoginResponseModel>> login({
    required String email,
    required String password,
  }) {
    return _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
      fromJson: (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  Future<ApiResult<ForgotPasswordResponseModel>> forgotPassword({
    required String email,
  }) {
    return _client.post(
      ApiEndpoints.forgotPassword,
      body: {'email': email},
      fromJson: (json) => ForgotPasswordResponseModel.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  Future<ApiResult<ResetPasswordResponseModel>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _client.post(
      ApiEndpoints.resetPassword,
      body: {'email': email, 'code': code, 'new_password': newPassword},
      fromJson: (json) =>
          ResetPasswordResponseModel.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  Future<ApiResult<void>> enableBiometrics({
    required String deviceId,
    required String publicKeySpkiBase64,
    String? deviceName,
  }) {
    return _client.post(
      ApiEndpoints.biometricsEnable,
      body: {
        'device_id': deviceId,
        'public_key': publicKeySpkiBase64,
        'algorithm': 'ES256',
        if (deviceName != null) 'device_name': deviceName,
      },
      fromJson: (_) {},
      requiresAuth: true,
    );
  }

  Future<ApiResult<BiometricChallengeModel>> requestBiometricChallenge({
    required String deviceId,
  }) {
    return _client.post(
      ApiEndpoints.biometricsChallenge,
      body: {'device_id': deviceId},
      fromJson: (json) =>
          BiometricChallengeModel.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  Future<ApiResult<LoginResponseModel>> loginWithBiometrics({
    required String deviceId,
    required String signatureBase64,
  }) {
    return _client.post(
      ApiEndpoints.biometricsLogin,
      body: {'device_id': deviceId, 'signature': signatureBase64},
      fromJson: (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
      requiresAuth: false,
    );
  }

  Future<ApiResult<dynamic>> logout({
    required String refreshToken,
    required bool allDevices,
  }) {
    return _client.post(
      ApiEndpoints.logout,
      body: {'refresh_token': refreshToken, 'all_devices': allDevices},
      fromJson: (json) => json,
      requiresAuth: true,
    );
  }
}
