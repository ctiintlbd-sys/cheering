import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.restaurantId,
    required super.dateFrom,
    required super.dateTo,
    required super.orders,
    required super.grossSales,
    required super.commission,
    required super.netPayout,
    required super.avgOrderValue,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final totals = json['totals'] as Map<String, dynamic>? ?? {};
    
    return ReportModel(
      restaurantId: json['restaurant_id'] as String? ?? '',
      dateFrom: json['date_from'] as String? ?? '',
      dateTo: json['date_to'] as String? ?? '',
      orders: (totals['orders'] as num?)?.toInt() ?? 0,
      grossSales: (totals['gross_sales'] as num?)?.toDouble() ?? 0.0,
      commission: (totals['commission'] as num?)?.toDouble() ?? 0.0,
      netPayout: (totals['net_payout'] as num?)?.toDouble() ?? 0.0,
      avgOrderValue: (totals['avg_order_value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'date_from': dateFrom,
      'date_to': dateTo,
      'totals': {
        'orders': orders,
        'gross_sales': grossSales,
        'commission': commission,
        'net_payout': netPayout,
        'avg_order_value': avgOrderValue,
      }
    };
  }
}
