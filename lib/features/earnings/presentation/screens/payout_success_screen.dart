import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PayoutSuccessScreen extends StatelessWidget {
  final double amount;
  final String methodName;
  final String accountNumber;
  final String transactionId;
  final String dateTime;

  const PayoutSuccessScreen({
    super.key,
    this.amount = 1000.0,
    this.methodName = 'Bkash',
    this.accountNumber = '017521455454',
    this.transactionId = 'CHR64445654#',
    this.dateTime = '06 Jun 2028, 10:25PM',
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0', 'en_US');
    final formattedAmount = '৳${currencyFormat.format(amount.toInt())}';

    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        showLeading: false,
        backgroundColor: Colors.transparent,
      ),
      bodyList: [
        SizedBox(height: 24.h),

        // ── 1. Success Icon with Outer Ring ──────────────────────
        Center(
          child: Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: context.colors.success,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.check_rounded,
                size: 32.sp,
                color: context.colors.white,
              ),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // ── 2. Success Title & Subtitle ──────────────────────────
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: 'Payout Successful!',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            CustomText(
              text: 'The withdrawal amount will received in short moment',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: context.colors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ).horizontal(20),

        SizedBox(height: 28.h),

        // ── 3. Transaction Details Card ──────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildDetailRow(context, 'Amount', formattedAmount),
              SizedBox(height: 14.h),
              _buildDetailRow(context, 'Payout Method', methodName),
              SizedBox(height: 14.h),
              _buildDetailRow(context, 'Payout Number', accountNumber),
              SizedBox(height: 14.h),
              _buildDetailRow(context, 'Transaction ID', transactionId),
              SizedBox(height: 14.h),
              _buildDetailRow(context, 'Date & Time', dateTime),
            ],
          ),
        ).horizontal(16),

        SizedBox(height: 32.h),
      ],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Back to Home Button ────────────────────────────────
          CustomButton(
            text: 'Back to Home',
            radius: 48,
            height: 48.h,
            onPressed: () {
              context.go(RoutePaths.ordersTab);
            },
          ),
          SizedBox(height: 12.h),

          // ── Receipt Button ─────────────────────────────────────
          CustomButton(
            text: 'Receipt',
            radius: 48,
            height: 48.h,
            backgroundColor: Colors.transparent,
            textColor: context.colors.textPrimary,
            borderColor: context.colors.borderSecondary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Receipt downloaded successfully!'),
                  backgroundColor: context.colors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: context.colors.textSecondary,
        ),
        CustomText(
          text: value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
        ),
      ],
    );
  }
}
