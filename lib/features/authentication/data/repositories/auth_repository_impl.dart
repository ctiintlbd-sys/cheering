import '../../../../core/network/api_result.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/entities/login_result_entity.dart';
import '../../domain/entities/reset_password_result_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteSource _source;

  AuthRepositoryImpl(this._source);

  @override
  Future<String> sendOtp({
    required String email,
    String role = 'CUSTOMER',
  }) async {
    final result = await _source.sendOtp(email: email, role: role);
    return result.fold(
      onSuccess: (data) => data.message,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<LoginResultEntity> verifyOtp({
    required String email,
    required String code,
    required String password,
    required String fullName,
  }) async {
    final result = await _source.verifyOtp(
      email: email,
      code: code,
      password: password,
      fullName: fullName,
    );
    return result.fold(
      onSuccess: (data) async {
        await TokenStorage.saveTokens(
          accessToken: data.tokens.accessToken,
          refreshToken: data.tokens.refreshToken,
        );
        return data;
      },
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<LoginResultEntity> login({
    required String email,
    required String password,
  }) async {
    final result = await _source.login(email: email, password: password);
    return result.fold(
      onSuccess: (data) async {
        await TokenStorage.saveTokens(
          accessToken: data.tokens.accessToken,
          refreshToken: data.tokens.refreshToken,
        );
        return data;
      },
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<AuthTokensEntity> loginWithGoogle() async {
    final tokens = await _source.loginWithGoogle();
    await TokenStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    return tokens;
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    final result = await _source.forgotPassword(email: email);
    return result.fold(
      onSuccess: (data) => data.message,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<ResetPasswordResultEntity> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final result = await _source.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<void> logout({
    required String refreshToken,
    required bool allDevices,
  }) async {
    final result = await _source.logout(
      refreshToken: refreshToken,
      allDevices: allDevices,
    );
    return result.fold(
      onSuccess: (_) async {
        await TokenStorage.clearTokens();
      },
      onFailure: (e) => throw e,
    );
  }
}
