class CacheKeys {
  CacheKeys._();

  static const String profile = 'profile_data';
  static const String addresses = 'addresses_data';
  static const String homeFeed = 'home_feed_data';
  static const String categories = 'categories_data';
  static String restaurants(Map<String, dynamic> query) =>
      'restaurants_${query.hashCode}';
  static String reels(Map<String, dynamic> query) => 'reels_${query.hashCode}';
  static const String cart = 'cart_data';
  static String checkoutSummary(Map<String, dynamic> query) =>
      'checkout_summary_${query.hashCode}';
  static String orders(Map<String, dynamic> query) =>
      'orders_${query.hashCode}';
  static String orderMessages(String orderId) => 'order_messages_$orderId';
  static const String favorites = 'favorites_data';
}
