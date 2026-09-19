import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

/// P-256 / ES256 helpers for `/auth/biometrics/*` (SubjectPublicKeyInfo + ECDSA DER).
class BiometricKeyService {
  static final ECDomainParameters _domain = ECCurve_secp256r1();

  ({String publicKeySpkiBase64, String privateKeyPkcs8Base64})
  generateKeyPair() {
    final secureRandom = FortunaRandom()..seed(KeyParameter(_secureSeed(32)));

    final generator = ECKeyGenerator()
      ..init(
        ParametersWithRandom(ECKeyGeneratorParameters(_domain), secureRandom),
      );

    final pair = generator.generateKeyPair();
    final privateKey = pair.privateKey;
    final publicKey = pair.publicKey;

    return (
      publicKeySpkiBase64: base64Encode(_encodeEcPublicKeySpki(publicKey)),
      privateKeyPkcs8Base64: base64Encode(
        _encodeEcPrivateKeyPkcs8(privateKey, publicKey),
      ),
    );
  }

  String signChallengeEs256Der({
    required String privateKeyPkcs8Base64,
    required String challenge,
  }) {
    final privateKey = _decodeEcPrivateKeyPkcs8(
      base64Decode(privateKeyPkcs8Base64),
    );
    final signer = ECDSASigner(SHA256Digest(), HMac(SHA256Digest(), 64))
      ..init(true, PrivateKeyParameter<ECPrivateKey>(privateKey));

    final sig =
        signer.generateSignature(Uint8List.fromList(utf8.encode(challenge)))
            as ECSignature;

    return base64Encode(_encodeEcdsaSignatureDer(sig.r, sig.s));
  }

  String createDeviceId() {
    return base64UrlEncode(_secureSeed(16)).replaceAll('=', '');
  }

  Uint8List _secureSeed(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => random.nextInt(256)),
    );
  }

  Uint8List _encodeEcPublicKeySpki(ECPublicKey publicKey) {
    final point = publicKey.Q!.getEncoded(false);

    final algorithmSeq = ASN1Sequence()
      ..add(ASN1ObjectIdentifier.fromComponentString('1.2.840.10045.2.1'))
      ..add(ASN1ObjectIdentifier.fromComponentString('1.2.840.10045.3.1.7'));

    final top = ASN1Sequence()
      ..add(algorithmSeq)
      ..add(ASN1BitString(point));

    return top.encodedBytes;
  }

  Uint8List _encodeEcPrivateKeyPkcs8(
    ECPrivateKey privateKey,
    ECPublicKey publicKey,
  ) {
    final ecPrivateKeySeq = ASN1Sequence()
      ..add(ASN1Integer(BigInt.one))
      ..add(ASN1OctetString(_bigIntTo32Bytes(privateKey.d!)))
      ..add(ASN1ObjectIdentifier.fromComponentString('1.2.840.10045.3.1.7'))
      ..add(ASN1BitString(publicKey.Q!.getEncoded(false)));

    final algorithmSeq = ASN1Sequence()
      ..add(ASN1ObjectIdentifier.fromComponentString('1.2.840.10045.2.1'));

    final top = ASN1Sequence()
      ..add(ASN1Integer(BigInt.zero))
      ..add(algorithmSeq)
      ..add(ASN1OctetString(ecPrivateKeySeq.encodedBytes));

    return top.encodedBytes;
  }

  ECPrivateKey _decodeEcPrivateKeyPkcs8(Uint8List pkcs8) {
    final top = ASN1Parser(pkcs8).nextObject() as ASN1Sequence;
    final ecPrivateKeyBytes = (top.elements[2] as ASN1OctetString).octets;
    final ecSeq = ASN1Parser(ecPrivateKeyBytes).nextObject() as ASN1Sequence;
    final dBytes = (ecSeq.elements[1] as ASN1OctetString).octets;
    return ECPrivateKey(_bytesToBigInt(dBytes), _domain);
  }

  Uint8List _bigIntTo32Bytes(BigInt value) {
    final hex = value.toRadixString(16).padLeft(64, '0');
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }

  BigInt _bytesToBigInt(Uint8List bytes) {
    var result = BigInt.zero;
    for (final byte in bytes) {
      result = (result << 8) | BigInt.from(byte);
    }
    return result;
  }

  Uint8List _encodeEcdsaSignatureDer(BigInt r, BigInt s) {
    final seq = ASN1Sequence()
      ..add(ASN1Integer(r))
      ..add(ASN1Integer(s));
    return seq.encodedBytes;
  }
}
