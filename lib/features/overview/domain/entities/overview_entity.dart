import 'package:intl/intl.dart';

class OverviewQueueEntity {
  final int newOrders;
  final int preparing;
  final int complete;
  final int ready;
  final int completedToday;

  const OverviewQueueEntity({
    this.newOrders = 0,
    this.preparing = 0,
    this.complete = 0,
    this.ready = 0,
    this.completedToday = 0,
  });
}

class OverviewDailyStatEntity {
  final String date;
  final int orders;
  final double earnings;

  const OverviewDailyStatEntity({
    required this.date,
    required this.orders,
    required this.earnings,
  });

  String get day {
    if (date.isEmpty) return '';
    try {
      final dt = DateTime.parse(date);
      return DateFormat('E').format(dt);
    } catch (_) {
      return date;
    }
  }

  double get value => earnings;

  bool get isHighlighted {
    if (date.isEmpty) return false;
    try {
      final dt = DateTime.parse(date);
      final now = DateTime.now();
      return dt.year == now.year && dt.month == now.month && dt.day == now.day;
    } catch (_) {
      return false;
    }
  }
}

class OverviewRecentOrderEntity {
  final String id;
  final String orderNumber;
  final String status;
  final String customerName;
  final double grandTotal;
  final String placedAt;

  const OverviewRecentOrderEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.customerName,
    required this.grandTotal,
    required this.placedAt,
  });

  double get price => grandTotal;

  String get timeAgo {
    if (placedAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(placedAt);
      final now = DateTime.now().toUtc();
      final difference = now.difference(dt.toUtc());

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM d').format(dt.toLocal());
      }
    } catch (_) {
      return placedAt;
    }
  }
}

class OverviewEntity {
  final String restaurantId;
  final String storeStatus;
  final bool isAcceptingOrders;
  final OverviewQueueEntity queue;
  final int todayOrders;
  final double todayEarnings;
  final double ratingAvg;
  final int ratingCount;
  final double acceptanceRate;
  final List<OverviewDailyStatEntity> last7Days;
  final List<OverviewRecentOrderEntity> recentOrders;

  const OverviewEntity({
    this.restaurantId = '',
    this.storeStatus = '',
    this.isAcceptingOrders = true,
    this.queue = const OverviewQueueEntity(),
    this.todayOrders = 0,
    this.todayEarnings = 0.0,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.acceptanceRate = 0.0,
    this.last7Days = const [],
    this.recentOrders = const [],
  });

  int get todayOrdersCount => todayOrders;
  double get rating => ratingAvg;
  List<OverviewDailyStatEntity> get weeklyStats => last7Days;
}
