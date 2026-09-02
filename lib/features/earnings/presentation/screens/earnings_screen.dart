import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final earningsState = context.watch<EarningsCubit>().state;
    final currencyFormat = NumberFormat('#,##0.00', 'en_US');
    final formattedTotal =
        '৳ ${currencyFormat.format(earningsState.totalEarning)}';

    return SliverScaffold(
      backgroundColor: context.colors.background,
      onRefresh: () async {
        context.read<EarningsCubit>().refresh();
      },
      appBar: CustomSliverAppBar(
        title: 'Earnings & payouts',
        centerTitle: true,
        showLeading: true,
        backAction: () => Navigator.pop(context),
      ),
      bodyList: [
        SizedBox(height: 16.h).asSliver,

        // ── 1. Total Earning Card ────────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Total Earning',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: context.colors.textSecondary,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: formattedTotal,
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
              ),
              SizedBox(height: 20.h),

              // Action Buttons Row (Cashout & Payout History)
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cashout',
                      radius: 48,
                      height: 44.h,
                      fontSize: 14.sp,
                      onPressed: () {
                        context.pushNamed(RoutePaths.cashoutMethods);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      text: 'Payout History',
                      radius: 48,
                      height: 44.h,
                      fontSize: 14.sp,
                      backgroundColor: Colors.transparent,
                      textColor: context.colors.textPrimary,
                      borderColor: context.colors.borderSecondary,
                      onPressed: () {
                        context.pushNamed(RoutePaths.payoutHistory);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 24.h).asSliver,

        // ── 2. Recent Transactions Header ────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Recent Transaction',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(RoutePaths.payoutHistory);
              },
              child: CustomText(
                text: 'See All',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: context.colors.primary,
              ),
            ),
          ],
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 12.h).asSliver,

        // ── 3. Recent Transactions List ──────────────────────────
        ...earningsState.recentTransactions.map((tx) {
          final formattedAmount =
              '+৳${tx.amount.toInt()}';

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: tx.orderNumber,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: tx.date,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                    CustomText(
                      text: formattedAmount,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: context.colors.success,
                    ),
                  ],
                ),
              ),
              Divider(
                color: context.colors.outline.withValues(alpha: 0.5),
                height: 1,
                thickness: 1,
              ),
            ],
          ).asSliver;
        }),

        SizedBox(height: 40.h).asSliver,
      ],
    );
  }
}
