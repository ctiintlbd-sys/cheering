import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/login_response_model.dart';

class GoogleAuthService {
  Future<AuthTokensModel> signIn() async {
    try {
      final baseUrl = AppConfig.instance.baseUrl;
      final redirectUri = Uri.encodeComponent(ApiEndpoints.googleRedirectUri);
      final authorizeUrl =
          '$baseUrl${ApiEndpoints.googleAuthorize}?redirect=$redirectUri';

      final result = await FlutterWebAuth2.authenticate(
        url: authorizeUrl,
        callbackUrlScheme: ApiEndpoints.googleCallbackScheme,
      );

      // Tokens come back in the URL fragment:
      // crshop://auth/callback#access_token=xxx&refresh_token=yyy&token_type=Bearer&expires_in=1800
      final params = Uri.splitQueryString(Uri.parse(result).fragment);
      final accessToken = params['access_token'] ?? '';
      final refreshToken = params['refresh_token'] ?? '';

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        final error = params['error'];
        throw BadRequestException(
          error ??
              'Failed to retrieve authentication tokens from Google login.',
        );
      }

      return AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: params['token_type'] ?? 'Bearer',
        expiresIn: int.tryParse(params['expires_in'] ?? '') ?? 1800,
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
}
