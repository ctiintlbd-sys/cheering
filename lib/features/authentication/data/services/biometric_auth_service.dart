import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/storage/biometric_device_storage.dart';
import '../datasources/auth_remote_source.dart';
import '../models/login_response_model.dart';
import 'biometric_key_service.dart';
import 'biometric_service.dart';

class BiometricAuthService {
  final AuthRemoteSource _remote;
  final BiometricKeyService _keyService;
  final BiometricService _biometricService;

  BiometricAuthService(
    this._remote,
    this._keyService,
    this._biometricService,
  );

  Future<void> enrollDevice({String? deviceName}) async {
    if (!await _biometricService.isBiometricsAvailable()) {
      throw const BadRequestException('Biometrics is not available on this device.');
    }

    final authenticated = await _biometricService.authenticate(
      localizedReason: 'Please authenticate to enable biometric login for Cheering',
    );
    if (!authenticated) {
      throw const CancelledException('Biometric verification cancelled or failed.');
    }

    final deviceId =
        BiometricDeviceStorage.deviceId ?? _keyService.createDeviceId();
    final keyPair = _keyService.generateKeyPair();

    final result = await _remote.enableBiometrics(
      deviceId: deviceId,
      publicKeySpkiBase64: keyPair.publicKeySpkiBase64,
      deviceName: deviceName,
    );

    result.fold(
      onSuccess: (_) async {
        await BiometricDeviceStorage.saveEnrollment(
          deviceId: deviceId,
          privateKeyPkcs8Base64: keyPair.privateKeyPkcs8Base64,
        );
        await _biometricService.setBiometricEnabled(true);
      },
      onFailure: (e) => throw e,
    );
  }

  Future<LoginResponseModel> loginWithDevice() async {
    if (!BiometricDeviceStorage.hasEnrollment) {
      throw const BadRequestException(
        'Biometric login is not set up. Enable it after signing in with password.',
      );
    }

    if (!await _biometricService.isBiometricsAvailable()) {
      throw const BadRequestException(
        'Biometrics is not available or enrolled on this device.',
      );
    }

    final authenticated = await _biometricService.authenticate(
      localizedReason: 'Scan fingerprint to log in to Cheering',
    );
    if (!authenticated) {
      throw const CancelledException('Biometric authentication cancelled or failed.');
    }

    final deviceId = BiometricDeviceStorage.deviceId!;
    final privateKey = BiometricDeviceStorage.privateKeyPkcs8Base64!;

    final challengeResult = await _remote.requestBiometricChallenge(deviceId: deviceId);
    final challenge = challengeResult.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );

    if (challenge.challenge.isEmpty) {
      throw const BadRequestException('Invalid biometric challenge from server.');
    }

    final signature = _keyService.signChallengeEs256Der(
      privateKeyPkcs8Base64: privateKey,
      challenge: challenge.challenge,
    );

    final loginResult = await _remote.loginWithBiometrics(
      deviceId: deviceId,
      signatureBase64: signature,
    );

    return loginResult.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }
}
