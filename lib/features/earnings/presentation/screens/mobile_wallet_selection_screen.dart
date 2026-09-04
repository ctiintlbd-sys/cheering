import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MobileWalletSelectionScreen extends StatefulWidget {
  final double? prefillAmount;

  const MobileWalletSelectionScreen({
    super.key,
    this.prefillAmount,
  });

  @override
  State<MobileWalletSelectionScreen> createState() =>
      _MobileWalletSelectionScreenState();
}

class _MobileWalletSelectionScreenState
    extends State<MobileWalletSelectionScreen> {
  bool _withdrawAllBalance = true;

  final List<Map<String, dynamic>> _wallets = [
    {
      'name': 'Bkash',
      'color': const Color(0xFFDF146E),
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'name': 'Nagad',
      'color': const Color(0xFFEC1C24),
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'name': 'Rocket',
      'color': const Color(0xFF8C3494),
      'icon': Icons.account_balance_wallet_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final earningsState = context.watch<EarningsCubit>().state;
    final availableBalance = earningsState.availableBalance;

    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        title: 'Payout to mobile wallet',
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

        // ── 2. Wallets List ──────────────────────────────────────
        ..._wallets.map((wallet) {
          final name = wallet['name'] as String;
          final color = wallet['color'] as Color;
          final icon = wallet['icon'] as IconData;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  context.pushNamed(
                    RoutePaths.withdrawForm,
                    extra: {
                      'methodType': 'wallet',
                      'methodName': name,
                      'methodColor': color,
                      'prefillAmount': _withdrawAllBalance
                          ? availableBalance
                          : widget.prefillAmount,
                    },
                  );
                },
                child: Container(
                  height: 52.h,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 32.r,
                            height: 32.r,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              icon,
                              size: 18.sp,
                              color: color,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          CustomText(
                            text: name,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.textPrimary,
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
              ),
              Divider(
                color: context.colors.outline.withValues(alpha: 0.5),
                height: 1,
                thickness: 1,
              ),
            ],
          ).horizontal(16);
        }),

        SizedBox(height: 40.h),
      ],
    );
  }
}
