abstract class RoutePaths {
  // ── Core ───────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // ── Auth & Onboarding (5 Steps) ───────────────────────────
  static const String login = '/login';
  static const String password = '/password';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otp = '/otp/:phone';
  static const String setPassword = '/set-password';
  static const String businessInformation = '/business-information';
  static const String location = '/location';
  static const String ownerInformation = '/owner-information';
  static const String document = '/document';
  static const String payoutMethod = '/payout-method';
  static const String review = '/review';
  static const String applicationSubmitted = '/application-submitted';

  static const String categoryDetails = '/category-details';

  // ── Main Tabs (Stateful Shell) ─────────────────────────────
  static const String foodTab = '/food';
  static const String storeTab = '/store';
  static const String ordersTab = '/orders';
  static const String communityTab = '/community';
  static const String profileTab = '/profile';

  // ── Orders (Deep Link Support) ─────────────────────────────
  static const String orderDetails = '/orders/:orderId';
  static const String orderHandoff = '/orders/:orderId/handoff';
  static const String orderCompleted = '/orders/:orderId/completed';
  static const String rejectOrder = '/orders/:orderId/reject';

  // ── Menu Management ────────────────────────────────────────
  static const String addMenuItem = '/menu/add';
  static const String commissionDetails = '/menu/commission';
  static const String productVariants = '/menu/variants';
  static const String productAddOns = '/menu/add-ons';
  static const String menuItemSuccess = '/menu/success';
  static const String manageCategories = '/menu/categories';

  // ── Profile & Store ────────────────────────────────────────
  static const String storeProfile = '/profile/store';
  static const String editStoreProfile = '/profile/edit';
  static const String updateLocation = '/profile/update-location';
  static const String businessHours = '/profile/business-hours';
  static const String editBusinessHours = '/profile/business-hours/edit';
  static const String customerFeedback = '/profile/feedback';
  static const String support = '/profile/support';
  static const String report = '/profile/report';

  // ── Earnings & Payouts ─────────────────────────────────────
  static const String payoutHistory = '/earnings/history';
  static const String cashoutMethods = '/earnings/cashout-methods';
  static const String mobileWalletSelection = '/earnings/mobile-wallet';
  static const String withdrawForm = '/earnings/withdraw';
  static const String payoutReview = '/earnings/payout-review';
  static const String payoutSuccess = '/earnings/payout-success';
  static const String earnings = '/earnings';


  // ── Performance & Promotions ───────────────────────────────
  static const String performance = '/performance';
  static const String promotions = '/promotions';
  static const String createPromotion = '/promotions/create';
  static const String promotionSuccess = '/promotions/success';
  static const String promotionDetails = '/promotions/:promoId';
}