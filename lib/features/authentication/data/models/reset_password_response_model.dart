class ResetPasswordResponseModel {
  final String message;
  final int sessionsRevoked;

  const ResetPasswordResponseModel({
    required this.message,
    required this.sessionsRevoked,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ResetPasswordResponseModel(
      message: data['message']?.toString() ?? 'Password updated',
      sessionsRevoked: data['sessions_revoked'] is int
          ? data['sessions_revoked'] as int
          : 0,
    );
  }
}
