import 'dart:convert';

import 'package:cheering/features/authentication/data/services/biometric_key_service.dart';
import 'package:cheering/features/authentication/data/services/biometric_service.dart';
import 'package:cheering/features/authentication/domain/entities/biometric_ui_kind.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  group('BiometricService.resolveUiKind', () {
    test('falls back to combined when the device reports nothing', () {
      expect(
        BiometricService.resolveUiKind(const []),
        BiometricUiKind.combined,
      );
    });

    test('uses face wording only for a face-only device', () {
      expect(
        BiometricService.resolveUiKind(const [BiometricType.face]),
        BiometricUiKind.face,
      );
    });

    test('uses touch wording when a fingerprint sensor is present', () {
      expect(
        BiometricService.resolveUiKind(const [BiometricType.fingerprint]),
        BiometricUiKind.touch,
      );
      expect(
        BiometricService.resolveUiKind(const [
          BiometricType.face,
          BiometricType.fingerprint,
        ]),
        BiometricUiKind.touch,
      );
    });

    test('uses touch wording for the strong/weak Android classes', () {
      expect(
        BiometricService.resolveUiKind(const [BiometricType.strong]),
        BiometricUiKind.touch,
      );
    });
  });

  group('BiometricKeyService', () {
    final service = BiometricKeyService();

    test('generates a P-256 key pair that round-trips through PKCS#8', () {
      final pair = service.generateKeyPair();

      expect(pair.publicKeySpkiBase64, isNotEmpty);
      expect(pair.privateKeyPkcs8Base64, isNotEmpty);

      // Signing proves the PKCS#8 blob decodes back to a usable private key.
      final signature = service.signChallengeEs256Der(
        privateKeyPkcs8Base64: pair.privateKeyPkcs8Base64,
        challenge: 'challenge-from-server',
      );

      expect(signature, isNotEmpty);
    });

    test('produces a DER sequence for the signature', () {
      final pair = service.generateKeyPair();
      final signature = service.signChallengeEs256Der(
        privateKeyPkcs8Base64: pair.privateKeyPkcs8Base64,
        challenge: 'abc',
      );

      // 0x30 is the DER SEQUENCE tag the backend expects for ECDSA.
      expect(base64Bytes(signature).first, 0x30);
    });

    test('creates url-safe device ids without padding', () {
      final deviceId = service.createDeviceId();

      expect(deviceId, isNot(contains('=')));
      expect(deviceId, isNot(contains('+')));
      expect(deviceId, isNot(contains('/')));
    });
  });
}

List<int> base64Bytes(String value) => const Base64Decoder().convert(value);
