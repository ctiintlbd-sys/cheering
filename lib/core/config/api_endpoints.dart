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

  // ── Profile ────────────────────────────────────────────────
  static const String profile = '/vendor/profile';

  // ── Menu ───────────────────────────────────────────────────
  static const String menu = '/vendor/menu';
  static const String menuCategories = '/vendor/menu/categories';
  static const String menuItems = '/vendor/menu/items';

  // ── Overview / Dashboard ──────────────────────────────────
  static const String dashboard = '/vendor/dashboard';
  static const String performance = '/vendor/performance';
  static const String analytics = '/vendor/analytics';
  // ── Orders ──────────────────────────────────────────────────
  static const String orders = '/vendor/orders';

  // ── Upload ─────────────────────────────────────────────────
  static const String presignedUpload = '/uploads/presigned-url';
  static const String uploadApplicationDoc = '/vendor/applications/uploads';
  static const String applicationsSubmit = '/vendor/applications';

  // ── Promotions ─────────────────────────────────────────────
  static const String promotions = '/vendor/promotions';

  // ── Business Hours ─────────────────────────────────────────
  static const String vendorHours = '/vendor/hours';
}
