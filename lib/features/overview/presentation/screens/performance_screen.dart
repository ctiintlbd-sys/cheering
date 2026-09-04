import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_state.dart';
import 'widgets/performance_shimmer.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        return SliverScaffold(
          backgroundColor: context.colors.background,
          appBar: CustomSliverAppBar(title: 'Performance & ratings'),
          bodyList: [
            SizedBox(height: 16.h),

            switch (state.performanceStatus) {
              PerformanceStatus.initial ||
              PerformanceStatus.loading => const PerformanceShimmer(),
              PerformanceStatus.failure => EmptyState(
                message:
                    state.performanceErrorMessage ??
                    'Failed to load performance',
              ),
              PerformanceStatus.success =>
                state.performance != null
                    ? SliverMainAxisGroup(
                        slivers: _buildPerformanceContent(context, state),
                      )
                    : SizedBox.shrink(),
            },

            SizedBox(height: 40.h),
          ],
        );
      },
    );
  }

  List<Widget> _buildPerformanceContent(
    BuildContext context,
    OverviewState state,
  ) {
    final performance = state.performance!;
    int formatRate(double rate) {
      if (rate <= 1.0) return (rate * 100).toInt();
      return rate.toInt();
    }

    final accRate = formatRate(performance.acceptanceRate);
    final onTime = formatRate(performance.onTimeRate);
    final rating = performance.ratingAvg;
    final rejections = performance.rejectionsThisWeek;

    return [
      // ── 1. 2x2 Metrics Grid ──────────────────────────────────
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  value: '$accRate%',
                  label: 'Acceptance rate',
                  isWarning: accRate < 85,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  value: '$onTime%',
                  label: 'On-time rate',
                  isWarning: onTime < 80,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  value: '${rating.toStringAsFixed(1)}★',
                  label: 'Customer rating',
                  isWarning: rating < 4.0 && performance.ratingCount > 0,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  value: '$rejections',
                  label: 'Rejections this week',
                  isWarning: rejections > 5,
                ),
              ),
            ],
          ),
        ],
      ).horizontal(16),

      SizedBox(height: 20.h),

      // ── 2. Acceptance Rate Warning Callout ────────────────────
      if (accRate < 85)
        CustomContainer(
          width: double.infinity,
          paddingAll: 16.r,
          radiusAll: 16.r,
          color: context.colors.bgSecondary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Acceptance rate below 85%',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB4720B),
              ),
              SizedBox(height: 8.h),
              CustomText(
                text:
                    'Repeated missed orders may reduce how often your store is shown to nearby customers.',
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8A5C09),
              ),
            ],
          ),
        ).horizontal(16),
    ];
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String value,
    required String label,
    required bool isWarning,
  }) {
    final bgColor = isWarning
        ? context.colors.bgWarningSecondary.withValues(alpha: 0.1)
        : context.colors.bgInfoPrimary.withValues(alpha: 0.1);

    final textColor = isWarning
        ? context.colors.bgWarningSecondary
        : context.colors.textPrimary;

    return CustomContainer(
      paddingAll: 16.r,
      radiusAll: 16.r,
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: value,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          SizedBox(height: 4.h),
          CustomText(text: label, color: context.colors.textSecondary),
        ],
      ),
    );
  }
}
