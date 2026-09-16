import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/entities/login_result_entity.dart';
import 'user_model.dart';

class AuthTokensModel extends AuthTokensEntity {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    super.tokenType,
    super.expiresIn,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      expiresIn: json['expires_in'] is int ? json['expires_in'] as int : 1800,
    );
  }
}

class LoginResponseModel extends LoginResultEntity {
  const LoginResponseModel({
    required AuthTokensModel tokens,
    required UserModel user,
  }) : super(tokens: tokens, user: user);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return LoginResponseModel(
      tokens: AuthTokensModel.fromJson(
        data['tokens'] is Map<String, dynamic>
            ? data['tokens'] as Map<String, dynamic>
            : {},
      ),
      user: UserModel.fromJson(
        data['user'] is Map<String, dynamic>
            ? data['user'] as Map<String, dynamic>
            : {},
      ),
    );
  }
}
