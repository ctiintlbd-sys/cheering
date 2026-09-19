class CacheKeys {
  CacheKeys._();

  static const String profile = 'profile_data';
  static const String addresses = 'addresses_data';
  static const String homeFeed = 'home_feed_data';
  static const String categories = 'categories_data';
  static String restaurants(Map<String, dynamic> query) => 'restaurants_${query.hashCode}';
}
