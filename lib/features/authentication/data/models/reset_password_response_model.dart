import '../../domain/entities/reset_password_result_entity.dart';

class ResetPasswordResponseModel extends ResetPasswordResultEntity {
  const ResetPasswordResponseModel({
    required super.message,
    required super.sessionsRevoked,
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
