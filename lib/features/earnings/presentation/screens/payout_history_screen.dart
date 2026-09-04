import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PayoutHistoryScreen extends StatelessWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final earningsState = context.watch<EarningsCubit>().state;
    final currencyFormat = NumberFormat('#,##0', 'en_US');

    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        title: 'Payout History',
        centerTitle: true,
        showLeading: true,
        backAction: () => Navigator.pop(context),
      ),
      bodyList: [
        SizedBox(height: 12.h),

        ...earningsState.payoutHistory.map((payout) {
          final formattedAmount =
              '৳ ${currencyFormat.format(payout.amount.toInt())}';

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: payout.date,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: context.colors.textPrimary,
                    ),
                    CustomText(
                      text: formattedAmount,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textPrimary,
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
          );
        }),

        SizedBox(height: 40.h),
      ],
    );
  }
}
