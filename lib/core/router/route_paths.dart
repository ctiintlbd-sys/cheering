abstract class RoutePaths {
  // ── Core ───────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // ── Auth & Onboarding (5 Steps) ───────────────────────────
  static const String login = '/login';
  static const String password = '/password';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp/:phone';
  static const String setPassword = '/set-password';
  static const String about = '/about';
  static const String enableBiometrics = '/enable-biometrics';

  static const String search = '/search';
  static const String reelsViewer = '/reels-viewer';
  static const String restaurantList = '/restaurant-list';
  static const String storeDetailsRoute = '/store-details/:id';
  static String storeDetails(String id) => '/store-details/$id';
  static const String itemDetails = '/item-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String placingOrder = '/placing-order';
  static const String orderPlaced = '/order-placed';
  static const String orderTracking = '/order-tracking/:id';
  static String tracking(String id) => '/order-tracking/$id';
  static const String orderTrackingMap = '/order-tracking-map';
  static const String riderChat = '/rider-chat/:id';
  static String riderChatPath(String id) => '/rider-chat/$id';
  static const String orderDetails = '/order-details/:id';
  static String details(String id) => '/order-details/$id';
  static const String rateOrder = '/rate-order';

  // ── Main Tabs (Stateful Shell) ─────────────────────────────
  static const String foodTab = '/food';
  static const String storeTab = '/store';
  static const String ordersTab = '/orders';
  static const String communityTab = '/community';
  static const String profileTab = '/profile';

  // ── Profile────────────────────────────────────────
  static const String accountSettings = '/profile/edit';
  static const String address = '/profile/address';
  static const String manualAddressMap = '/profile/address/manual-map';
  static const String addAddress = '/profile/address/add';
}
