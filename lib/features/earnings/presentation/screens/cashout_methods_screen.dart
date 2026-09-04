import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CashoutMethodsScreen extends StatefulWidget {
  const CashoutMethodsScreen({super.key});

  @override
  State<CashoutMethodsScreen> createState() =>
      _CashoutMethodsScreenState();
}

class _CashoutMethodsScreenState extends State<CashoutMethodsScreen> {
  bool _withdrawAllBalance = true;

  @override
  Widget build(BuildContext context) {
    final earningsState = context.watch<EarningsCubit>().state;
    final availableBalance = earningsState.availableBalance;

    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        title: 'Payout',
        centerTitle: true,
        showLeading: true,
        backAction: () => Navigator.pop(context),
      ),
      bodyList: [
        SizedBox(height: 16.h),

        // ── 1. Withdraw all balance Checkbox ─────────────────────
        InkWell(
          onTap: () {
            setState(() {
              _withdrawAllBalance = !_withdrawAllBalance;
            });
          },
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Checkbox(
                  value: _withdrawAllBalance,
                  activeColor: context.colors.primary,
                  onChanged: (val) {
                    setState(() {
                      _withdrawAllBalance = val ?? false;
                    });
                  },
                ),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Withdraw all balance ৳${availableBalance.toInt()}',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: context.colors.textPrimary,
                ),
              ],
            ),
          ),
        ).horizontal(16),

        SizedBox(height: 16.h),

        // ── 2. Method Option 1: With via Bank Account ────────────
        _buildMethodTile(
          icon: Icons.account_balance_outlined,
          title: 'With via Bank Account',
          onTap: () {
            context.pushNamed(
              RoutePaths.withdrawForm,
              extra: {
                'methodType': 'bank',
                'methodName': 'Bank Account',
                'prefillAmount': _withdrawAllBalance ? availableBalance : null,
              },
            );
          },
        ).horizontal(16),

        Divider(
          color: context.colors.outline.withValues(alpha: 0.5),
          height: 1,
          thickness: 1,
        ).horizontal(16),

        // ── 3. Method Option 2: Withdraw via Mobile wallet ───────
        _buildMethodTile(
          icon: Icons.phone_android_rounded,
          title: 'Withdraw via Mobile wallet',
          onTap: () {
            context.pushNamed(
              RoutePaths.mobileWalletSelection,
              extra: {
                'prefillAmount': _withdrawAllBalance ? availableBalance : null,
              },
            );
          },
        ).horizontal(16),

        Divider(
          color: context.colors.outline.withValues(alpha: 0.5),
          height: 1,
          thickness: 1,
        ).horizontal(16),

        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildMethodTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20.sp,
                  color: context.colors.textSecondary,
                ),
                SizedBox(width: 12.w),
                CustomText(
                  text: title,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22.sp,
              color: context.colors.textPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}
