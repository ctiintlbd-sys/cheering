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

  static const String categoryDetails = '/category-details';
  static const String storeDetails = '/store-details';
  static const String itemDetails = '/item-details';

  // ── Main Tabs (Stateful Shell) ─────────────────────────────
  static const String foodTab = '/food';
  static const String storeTab = '/store';
  static const String ordersTab = '/orders';
  static const String communityTab = '/community';
  static const String profileTab = '/profile';

  // ── Profile────────────────────────────────────────
  static const String accountSettings = '/profile/edit';
  static const String address = '/profile/address';
}
