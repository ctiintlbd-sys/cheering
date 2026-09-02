import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PayoutReviewScreen extends StatelessWidget {
  final double amount;
  final String methodType;
  final String methodName;
  final Color methodColor;
  final String accountNumber;
  final String beneficiaryName;

  const PayoutReviewScreen({
    super.key,
    this.amount = 12000.0,
    this.methodType = 'wallet',
    this.methodName = 'Bkash',
    this.methodColor = const Color(0xFFDF146E),
    this.accountNumber = '017521455454',
    this.beneficiaryName = 'Tanvir Hridoy',
  });

  void _onConfirm(BuildContext context) {
    context.read<EarningsCubit>().processPayout(
          amount: amount,
          method: methodName,
          accountOrPhone: accountNumber,
          beneficiaryName: beneficiaryName,
        );

    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mma');
    final formattedDate = dateFormat.format(now);

    context.pushReplacementNamed(
      RoutePaths.payoutSuccess,
      extra: {
        'amount': amount,
        'methodName': methodName,
        'accountNumber': accountNumber,
        'transactionId': 'CHR${now.millisecondsSinceEpoch.toString().substring(5)}#',
        'dateTime': formattedDate,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0', 'en_US');
    final formattedAmount = '৳${currencyFormat.format(amount.toInt())}';

    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        title: methodType == 'bank'
            ? 'Payout to bank account'
            : 'Payout to mobile wallet',
        centerTitle: true,
        showLeading: true,
        backAction: () => Navigator.pop(context),
      ),
      bodyList: [
        SizedBox(height: 16.h).asSliver,

        // ── 1. Transaction Review Card ───────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payout Money Amount
              CustomText(
                text: 'Payout Money',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: context.colors.textSecondary,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: formattedAmount,
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
              SizedBox(height: 16.h),

              // Divider Line
              Divider(
                color: context.colors.outline,
                height: 1,
                thickness: 1,
              ),
              SizedBox(height: 16.h),

              // Payout Method Section
              CustomText(
                text: 'Payout Method',
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: context.colors.textSecondary,
              ),
              SizedBox(height: 12.h),

              Row(
                children: [
                  // Method Logo Circle
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: methodColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      methodType == 'bank'
                          ? Icons.account_balance_rounded
                          : Icons.account_balance_wallet_rounded,
                      size: 22.sp,
                      color: methodColor,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Method Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: methodName,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textSecondary,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: accountNumber,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 40.h).asSliver,
      ],
      bottomNavigationBar: CustomButton(
        text: 'Confirm',
        radius: 48,
        height: 48.h,
        onPressed: () => _onConfirm(context),
      ),
    );
  }
}
