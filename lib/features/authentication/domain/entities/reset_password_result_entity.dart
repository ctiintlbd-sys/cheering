class ResetPasswordResultEntity {
  final String message;
  final int sessionsRevoked;

  const ResetPasswordResultEntity({
    required this.message,
    required this.sessionsRevoked,
  });
}
