import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String restaurantId;
  final String dateFrom;
  final String dateTo;
  final int orders;
  final double grossSales;
  final double commission;
  final double netPayout;
  final double avgOrderValue;

  const ReportEntity({
    required this.restaurantId,
    required this.dateFrom,
    required this.dateTo,
    required this.orders,
    required this.grossSales,
    required this.commission,
    required this.netPayout,
    required this.avgOrderValue,
  });

  @override
  List<Object?> get props => [
        restaurantId,
        dateFrom,
        dateTo,
        orders,
        grossSales,
        commission,
        netPayout,
        avgOrderValue,
      ];
}
