import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/entities/login_result_entity.dart';
import '../../domain/entities/user_entity.dart';

class AuthTokensModel extends AuthTokensEntity {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.role,
    required super.email,
    required super.phone,
    required super.fullName,
    super.avatarUrl,
    required super.isEmailVerified,
    required super.isPhoneVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name.toUpperCase() == json['role']?.toString().toUpperCase(),
        orElse: () => UserRole.unknown,
      ),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      isEmailVerified: json['is_email_verified'] == true,
      isPhoneVerified: json['is_phone_verified'] == true,
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
