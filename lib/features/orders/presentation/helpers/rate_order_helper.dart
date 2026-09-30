abstract final class RateOrderHelper {
  static const List<String> tags = [
    'Great taste',
    'Fast delivery',
    'Good packaging',
    'Accurate order',
    'Friendly rider',
  ];

  static int calculateDeliveryMinutes(DateTime? placedAt, DateTime? deliveredAt) {
    if (placedAt == null || deliveredAt == null) return 0;
    final diff = deliveredAt.difference(placedAt);
    return diff.inMinutes > 0 ? diff.inMinutes : 0;
  }
}
