import '../../../../core/network/api_result.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../profile/data/datasources/profile_remote_source.dart';
import '../../domain/entities/login_result_entity.dart';
import '../../domain/entities/reset_password_result_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_source.dart';
import '../services/biometric_auth_service.dart';
import '../services/google_auth_service.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteSource _source;
  final GoogleAuthService _googleAuthService;
  final BiometricAuthService _biometricAuthService;
  final ProfileRemoteSource _profileRemoteSource;

  AuthRepositoryImpl(
    this._source,
    this._googleAuthService,
    this._biometricAuthService,
    this._profileRemoteSource,
  );

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
  Future<LoginResultEntity> loginWithGoogle() async {
    final tokens = await _googleAuthService.signIn();
    await TokenStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    final userResult = await _profileRemoteSource.getProfile();
    return userResult.fold(
      onSuccess: (user) => LoginResultEntity(tokens: tokens, user: user),
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<void> enrollBiometricLogin({String? deviceName}) {
    return _biometricAuthService.enrollDevice(deviceName: deviceName);
  }

  @override
  Future<LoginResultEntity> loginWithBiometric() async {
    final data = await _biometricAuthService.loginWithDevice();
    await TokenStorage.saveTokens(
      accessToken: data.tokens.accessToken,
      refreshToken: data.tokens.refreshToken,
    );
    return data;
  }

  @override
  Future<bool> hasStoredSession() async {
    final token = TokenStorage.refreshToken;
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearLocalSession() => TokenStorage.clearTokens();

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
  Future<void> logout({bool allDevices = false}) async {
    final refreshToken = TokenStorage.refreshToken ?? '';

    try {
      if (refreshToken.isNotEmpty) {
        final result = await _source.logout(
          refreshToken: refreshToken,
          allDevices: allDevices,
        );
        result.fold(
          onSuccess: (_) {
          },
          onFailure: (e) => throw e,
        );
      }
    } finally {
      await TokenStorage.clearTokens();
    }
  }
}
