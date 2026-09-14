class BiometricChallengeModel {
  final String challenge;
  final int expiresIn;

  const BiometricChallengeModel({
    required this.challenge,
    required this.expiresIn,
  });

  factory BiometricChallengeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return BiometricChallengeModel(
      challenge: data['challenge']?.toString() ?? '',
      expiresIn: data['expires_in'] is int ? data['expires_in'] as int : 120,
    );
  }
}
