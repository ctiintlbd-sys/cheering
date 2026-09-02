import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class WithdrawFormScreen extends StatefulWidget {
  final String methodType; // 'wallet' or 'bank'
  final String methodName; // 'Bkash', 'Nagad', 'Rocket', or 'Bank Account'
  final Color? methodColor;
  final double? prefillAmount;

  const WithdrawFormScreen({
    super.key,
    this.methodType = 'wallet',
    this.methodName = 'Bkash',
    this.methodColor,
    this.prefillAmount,
  });

  @override
  State<WithdrawFormScreen> createState() => _WithdrawFormScreenState();
}

class _WithdrawFormScreenState extends State<WithdrawFormScreen> {
  late final TextEditingController _accountController;
  late final TextEditingController _amountController;
  late final TextEditingController _beneficiaryController;

  bool _withdrawAllBalance = false;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(text: '017521455454');
    _amountController = TextEditingController(
      text: widget.prefillAmount != null
          ? widget.prefillAmount!.toInt().toString()
          : '12000',
    );
    _beneficiaryController = TextEditingController(text: 'Tanvir Hridoy');
    _withdrawAllBalance = widget.prefillAmount != null;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _beneficiaryController.dispose();
    super.dispose();
  }

  void _onWithdrawMoney(double availableBalance) {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final account = _accountController.text.trim();
    final beneficiary = _beneficiaryController.text.trim();

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid amount'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    if (amount > availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Amount exceeds available balance'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    context.pushNamed(
      RoutePaths.payoutReview,
      extra: {
        'amount': amount,
        'methodType': widget.methodType,
        'methodName': widget.methodName,
        'methodColor': widget.methodColor ?? context.colors.primary,
        'accountNumber': account.isEmpty ? '017521455454' : account,
        'beneficiaryName': beneficiary.isEmpty ? 'Tanvir Hridoy' : beneficiary,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final earningsState = context.watch<EarningsCubit>().state;
    final availableBalance = earningsState.availableBalance;
    final currencyFormat = NumberFormat('#,##0.00', 'en_US');
    final formattedBalance =
        '৳ ${currencyFormat.format(availableBalance)}';

    final isBank = widget.methodType == 'bank';
    final titleText =
        isBank ? 'Payout to bank account' : 'Payout to mobile wallet';

    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        title: titleText,
        centerTitle: true,
        showLeading: true,
        backAction: () => Navigator.pop(context),
      ),
      bodyList: [
        SizedBox(height: 16.h).asSliver,

        // ── 1. Withdraw all balance Checkbox ─────────────────────
        InkWell(
          onTap: () {
            setState(() {
              _withdrawAllBalance = !_withdrawAllBalance;
              if (_withdrawAllBalance) {
                _amountController.text = availableBalance.toInt().toString();
              }
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
                      if (_withdrawAllBalance) {
                        _amountController.text =
                            availableBalance.toInt().toString();
                      }
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
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 16.h).asSliver,

        // ── 2. Available Balance Header Card ─────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16.sp,
                    color: context.colors.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: 'Available balance',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: formattedBalance,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ],
          ),
        ).asSliver,

        SizedBox(height: 12.h).asSliver,

        // ── 3. Input Fields ──────────────────────────────────────
        // Field 1: Account or Mobile number
        _buildInputField(
          label: isBank ? 'Account Number' : 'Withdraw to ',
          controller: _accountController,
          hintText: isBank
              ? 'Enter bank account number'
              : 'Enter mobile number or Name',
          suffixIcon: Icons.perm_contact_calendar_outlined,
          keyboardType: TextInputType.phone,
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 14.h).asSliver,

        // Field 2: Amount
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Amount',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: context.colors.textPrimary,
            ),
            SizedBox(height: 8.h),
            Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: context.colors.bgSecondary,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: context.colors.outline,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomText(
                    text: '৳',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: context.colors.textPlaceholder,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 14.h).asSliver,

        // Field 3: Beneficiary Name
        _buildInputField(
          label: 'Add Beneficiary Name',
          controller: _beneficiaryController,
          hintText: 'Type name here',
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 32.h).asSliver,
      ],
      bottomNavigationBar: CustomButton(
        text: 'Withdraw Money',
        radius: 48,
        height: 48.h,
        onPressed: () => _onWithdrawMoney(availableBalance),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: context.colors.textPrimary,
        ),
        SizedBox(height: 8.h),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: context.colors.textPlaceholder,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (suffixIcon != null)
                Icon(
                  suffixIcon,
                  size: 20.sp,
                  color: context.colors.textSecondary,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
