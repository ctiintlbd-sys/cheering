import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_exception.dart';
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

  Future<AuthTokensModel> loginWithGoogle() async {
    try {
      final baseUrl = AppConfig.instance.baseUrl;
      final redirectUri = Uri.encodeComponent(ApiEndpoints.googleRedirectUri);
      final authorizeUrl = '$baseUrl${ApiEndpoints.googleAuthorize}?redirect=$redirectUri';

      final result = await FlutterWebAuth2.authenticate(
        url: authorizeUrl,
        callbackUrlScheme: ApiEndpoints.googleCallbackScheme,
      );

      final uri = Uri.parse(result.replaceFirst('#', '?'));
      final accessToken = uri.queryParameters['access_token'] ?? '';
      final refreshToken = uri.queryParameters['refresh_token'] ?? '';

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        final error = uri.queryParameters['error'];
        throw BadRequestException(
          error ?? 'Failed to retrieve authentication tokens from Google login.',
        );
      }

      return AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: uri.queryParameters['token_type'] ?? 'Bearer',
        expiresIn: int.tryParse(uri.queryParameters['expires_in'] ?? '') ?? 1800,
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        throw const CancelledException('Google sign-in was cancelled.');
      }
      throw BadRequestException(e.message ?? 'Google sign-in failed.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
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
