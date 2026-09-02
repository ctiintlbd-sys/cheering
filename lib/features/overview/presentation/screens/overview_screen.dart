import 'dart:async';
import 'package:cheering/core/models/weekly_chart_item.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/overview/presentation/bloc/overview_bloc.dart';
import 'package:cheering/features/overview/presentation/bloc/overview_event.dart';
import 'package:cheering/features/overview/presentation/bloc/overview_state.dart';
import 'package:cheering/features/overview/presentation/screens/widgets/overview_recent_order_card.dart';
import 'package:cheering/features/overview/presentation/screens/widgets/overview_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'widgets/overview_earnings_card.dart';
import '../../../../core/widgets/weekly_chart.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        final overview = state.overview;
        return SliverScaffold(
          onRefresh: () async {
            final completer = Completer<void>();
            context.read<OverviewBloc>().add(LoadOverview(completer: completer));
            return completer.future;
          },
          appBar: CustomSliverAppBar(
            title: 'Overview',
            expandedHeight: 490.h,
            flexibleChild: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: switch (state.status) {
                OverviewStatus.initial ||
                OverviewStatus.loading => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const OverviewEarningsCardShimmer(),
                    SizedBox(height: 20.h),
                    const OverviewChartShimmer(),
                    SizedBox(height: 20.h),
                  ],
                ),
                OverviewStatus.failure => const SizedBox.shrink(),
                OverviewStatus.success when overview != null => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Today's Earnings Card ──────────────────────────────
                    OverviewEarningsCard(
                      todayEarnings: overview.todayEarnings,
                      ordersCount: overview.todayOrdersCount,
                      rating: overview.rating,
                      acceptanceRate: overview.acceptanceRate,
                    ),

                    SizedBox(height: 20.h),

                    // ── Weekly Bar Chart ───────────────────────────────────
                    WeeklyChart(
                      weeklyStats: overview.weeklyStats
                          .map(
                            (item) => WeeklyChartItem(
                          date: item.date,
                          day: item.day,
                          value: item.value,
                          earnings: item.earnings,
                          orders: item.orders,
                          isHighlighted: item.isHighlighted,
                        ),
                      )
                          .toList(),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
                OverviewStatus.success => const SizedBox.shrink(),
              },
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(28.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Recent Order',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.go(RoutePaths.ordersTab);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: 'See All',
                            fontWeight: FontWeight.w600,
                            color: context.colors.textSecondary,
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18.sp,
                            color: context.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bodyList: [
            SizedBox(height: 10.h).asSliver,

            switch (state.status) {
              OverviewStatus.initial ||
              OverviewStatus.loading => const OverviewRecentOrdersShimmer(),
              OverviewStatus.failure => EmptyState(
                message: state.errorMessage ?? 'Failed to load overview data',
              ),
              OverviewStatus.success when overview == null || overview.recentOrders.isEmpty =>
                const EmptyState(
                  message: 'No recent orders available',
                ),
              OverviewStatus.success => SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList.separated(
                  itemCount: overview!.recentOrders.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final order = overview.recentOrders[index];
                    return OverviewRecentOrderCard(
                      key: ValueKey(order.id),
                      order: order,
                      onTap: () {
                        // On order tap
                      },
                    );
                  },
                ),
              ),
            },

            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 80.h,
            ).asSliver,
          ],
        );
      },
    );
  }
}
