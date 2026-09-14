import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
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

  Future<ApiResult<UserModel>> getCurrentUser() {
    return _client.get(
      ApiEndpoints.currentUser,
      fromJson: (json) {
        final map = json is Map<String, dynamic> ? json : <String, dynamic>{};
        final data = map['data'] is Map<String, dynamic>
            ? map['data'] as Map<String, dynamic>
            : map;
        return UserModel.fromJson(data);
      },
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
