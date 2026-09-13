import '../entities/auth_tokens_entity.dart';
import '../entities/login_result_entity.dart';
import '../entities/reset_password_result_entity.dart';

abstract class IAuthRepository {
  Future<String> sendOtp({
    required String email,
    String role = 'CUSTOMER',
  });

  Future<LoginResultEntity> verifyOtp({
    required String email,
    required String code,
    required String password,
    required String fullName,
  });

  Future<LoginResultEntity> login({
    required String email,
    required String password,
  });

  Future<AuthTokensEntity> loginWithGoogle();

  Future<String> forgotPassword({
    required String email,
  });

  Future<ResetPasswordResultEntity> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<void> logout({
    required String refreshToken,
    required bool allDevices,
  });
}
