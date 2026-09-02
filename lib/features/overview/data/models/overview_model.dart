import '../../domain/entities/overview_entity.dart';

class OverviewQueueModel extends OverviewQueueEntity {
  const OverviewQueueModel({
    super.newOrders,
    super.preparing,
    super.complete,
    super.ready,
    super.completedToday,
  });

  factory OverviewQueueModel.fromJson(Map<String, dynamic> json) {
    return OverviewQueueModel(
      newOrders: (json['new'] as num?)?.toInt() ?? 0,
      preparing: (json['preparing'] as num?)?.toInt() ?? 0,
      complete: (json['complete'] as num?)?.toInt() ?? 0,
      ready: (json['ready'] as num?)?.toInt() ?? 0,
      completedToday: (json['completed_today'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'new': newOrders,
        'preparing': preparing,
        'complete': complete,
        'ready': ready,
        'completed_today': completedToday,
      };
}

class OverviewDailyStatModel extends OverviewDailyStatEntity {
  const OverviewDailyStatModel({
    required super.date,
    required super.orders,
    required super.earnings,
  });

  factory OverviewDailyStatModel.fromJson(Map<String, dynamic> json) {
    return OverviewDailyStatModel(
      date: json['date']?.toString() ?? '',
      orders: (json['orders'] as num?)?.toInt() ?? 0,
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'orders': orders,
        'earnings': earnings,
      };
}

class OverviewRecentOrderModel extends OverviewRecentOrderEntity {
  const OverviewRecentOrderModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.customerName,
    required super.grandTotal,
    required super.placedAt,
  });

  factory OverviewRecentOrderModel.fromJson(Map<String, dynamic> json) {
    final rawOrderNumber = json['order_number'] ?? json['orderNumber'];
    final formattedOrderNumber = rawOrderNumber != null
        ? (rawOrderNumber.toString().startsWith('#')
            ? rawOrderNumber.toString()
            : '#$rawOrderNumber')
        : '';

    return OverviewRecentOrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: formattedOrderNumber,
      status: json['status']?.toString() ?? '',
      customerName:
          json['customer_name']?.toString() ?? json['customerName']?.toString() ?? '',
      grandTotal: (json['grand_total'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      placedAt:
          json['placed_at']?.toString() ?? json['placedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'status': status,
        'customer_name': customerName,
        'grand_total': grandTotal,
        'placed_at': placedAt,
      };
}

class OverviewDataModel extends OverviewEntity {
  const OverviewDataModel({
    super.restaurantId,
    super.storeStatus,
    super.isAcceptingOrders,
    super.queue,
    super.todayOrders,
    super.todayEarnings,
    super.ratingAvg,
    super.ratingCount,
    super.acceptanceRate,
    super.last7Days,
    super.recentOrders,
  });

  factory OverviewDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return OverviewDataModel(
      restaurantId: data['restaurant_id']?.toString() ?? '',
      storeStatus: data['store_status']?.toString() ?? '',
      isAcceptingOrders: data['is_accepting_orders'] == true,
      queue: data['queue'] is Map<String, dynamic>
          ? OverviewQueueModel.fromJson(data['queue'] as Map<String, dynamic>)
          : const OverviewQueueModel(),
      todayOrders: (data['today_orders'] as num?)?.toInt() ?? 0,
      todayEarnings: (data['today_earnings'] as num?)?.toDouble() ?? 0.0,
      ratingAvg: (data['rating_avg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (data['rating_count'] as num?)?.toInt() ?? 0,
      acceptanceRate: (data['acceptance_rate'] as num?)?.toDouble() ?? 0.0,
      last7Days: (data['last_7_days'] as List<dynamic>?)
              ?.map((e) =>
                  OverviewDailyStatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentOrders: (data['recent_orders'] as List<dynamic>?)
              ?.map((e) =>
                  OverviewRecentOrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'restaurant_id': restaurantId,
        'store_status': storeStatus,
        'is_accepting_orders': isAcceptingOrders,
        'queue': (queue as OverviewQueueModel).toJson(),
        'today_orders': todayOrders,
        'today_earnings': todayEarnings,
        'rating_avg': ratingAvg,
        'rating_count': ratingCount,
        'acceptance_rate': acceptanceRate,
        'last_7_days': last7Days
            .map((d) => (d as OverviewDailyStatModel).toJson())
            .toList(),
        'recent_orders': recentOrders
            .map((r) => (r as OverviewRecentOrderModel).toJson())
            .toList(),
      };
}

