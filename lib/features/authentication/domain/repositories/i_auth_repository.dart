import '../entities/login_result_entity.dart';

abstract class IAuthRepository {
  Future<LoginResultEntity> login({
    required String email,
    required String password,
  });

  Future<String> forgotPassword({
    required String email,
  });

  Future<String> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<void> logout({
    required String refreshToken,
    required bool allDevices,
  });
}
