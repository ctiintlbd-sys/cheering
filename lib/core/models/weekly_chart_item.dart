class WeeklyChartItem {
  final String date;
  final String day;
  final double value;
  final double earnings;
  final int orders;
  final bool isHighlighted;

  const WeeklyChartItem({
    required this.date,
    required this.day,
    required this.value,
    required this.earnings,
    required this.orders,
    this.isHighlighted = false,
  });
}