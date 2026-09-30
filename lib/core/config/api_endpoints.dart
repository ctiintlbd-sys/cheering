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
  static const String addresses = '/users/me/addresses';

  // ── Upload ─────────────────────────────────────────────────
  static const String presignedUpload = '/uploads/presigned-url';
  static const String uploadApplicationDoc = '/vendor/applications/uploads';
  static const String applicationsSubmit = '/vendor/applications';

  // ── Food ───────────────────────────────────────────────────
  static const String homeFeed = '/home/feed';
  static const String restaurants = '/restaurants';
  static String restaurantDetails(String id) => '/restaurants/$id';
  static String restaurantMenu(String id) => '/restaurants/$id/menu';
  static const String categories = '/categories';
  static const String search = '/search';

  // ── Cart & Checkout ────────────────────────────────────────
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static String cartItem(String lineId) => '/cart/items/$lineId';
  static const String checkoutSummary = '/checkout/summary';

  // ── Orders ──────────────────────────────────────────────────
  static const String orders = '/orders';
  static String orderDetails(String id) => '/orders/$id';
  static String cancelOrder(String id) => '/orders/$id/cancel';
  static String orderTracking(String id) => '/orders/$id/tracking';
  static String orderReviews(String id) => '/orders/$id/reviews';
}
