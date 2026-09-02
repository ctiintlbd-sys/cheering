import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OverviewEarningsCard extends StatelessWidget {
  final double todayEarnings;
  final int ordersCount;
  final double rating;
  final double acceptanceRate;

  const OverviewEarningsCard({
    super.key,
    required this.todayEarnings,
    required this.ordersCount,
    required this.rating,
    required this.acceptanceRate,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0', 'en_US');
    final formattedEarnings = '৳${currencyFormat.format(todayEarnings.toInt())}';
    final formattedRating = rating > 0 ? rating.toStringAsFixed(1) : '0';
    final formattedAcceptance = (acceptanceRate <= 1.0 && acceptanceRate > 0)
        ? '${(acceptanceRate * 100).toInt()}%'
        : (acceptanceRate == 1.0 ? '100%' : '${acceptanceRate.toInt()}%');

    return CustomContainer(
      width: double.infinity,
      color: context.colors.bgSecondary,
      radiusAll: 16,
      bordersColor: context.colors.borderTertiary,
      paddingAll: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top Earnings Section ───────────────────────────────
          CustomText(
            text: "Today's earnings",
            color: context.colors.textSecondary,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: formattedEarnings,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 12.h),

          // ── Divider ───────────────────────────────────────────
          Container(
            height: 0.8.h,
            width: double.infinity,
            color: context.colors.borderSecondary,
          ),
          SizedBox(height: 10.h),

          // ── Bottom Metrics Row ─────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(
                context,
                label: 'Orders',
                value: '$ordersCount',
              ),
              _buildMetricItem(
                context,
                label: 'Rating',
                value: '$formattedRating★',
              ),
              _buildMetricItem(
                context,
                label: 'Acceptance',
                value: formattedAcceptance,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: label,
          color: context.colors.textSecondary,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
