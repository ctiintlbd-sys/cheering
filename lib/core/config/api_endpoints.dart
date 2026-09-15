class ApiEndpoints {
  ApiEndpoints._();

  // ── Timeouts ───────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ── Auth ───────────────────────────────────────────────────
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/password/forgot';
  static const String resetPassword = '/auth/password/reset';
  static const String logout = '/auth/logout';
  static const String googleAuthorize = '/auth/google/authorize';
  static const String googleRedirectUri = 'crshop://auth/callback';
  static const String googleCallbackScheme = 'crshop';

  static const String biometricsEnable = '/auth/biometrics/enable';
  static const String biometricsChallenge = '/auth/biometrics/challenge';
  static const String biometricsLogin = '/auth/biometrics/login';

  // ── Profile ────────────────────────────────────────────────
  static const String profile = '/users/me/profile';
  static const String currentUser = '/users/me';

  // ── Upload ─────────────────────────────────────────────────
  static const String presignedUpload = '/uploads/presigned-url';
  static const String uploadApplicationDoc = '/vendor/applications/uploads';
  static const String applicationsSubmit = '/vendor/applications';
}
