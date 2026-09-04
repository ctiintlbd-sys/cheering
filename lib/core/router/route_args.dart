import 'package:flutter/material.dart';

class WithdrawFormArgs {
  final String methodType;
  final String methodName;
  final Color? methodColor;
  final double? prefillAmount;

  const WithdrawFormArgs({
    this.methodType = 'wallet',
    this.methodName = 'Bkash',
    this.methodColor,
    this.prefillAmount,
  });

  factory WithdrawFormArgs.fromQuery(Map<String, String> query) {
    return WithdrawFormArgs(
      methodType: query['type'] ?? 'wallet',
      methodName: query['name'] ?? 'Bkash',
      prefillAmount: double.tryParse(query['amount'] ?? ''),
    );
  }
}

class PayoutReviewArgs {
  final double amount;
  final String methodType;
  final String methodName;
  final Color methodColor;
  final String accountNumber;
  final String beneficiaryName;

  const PayoutReviewArgs({
    required this.amount,
    required this.methodName,
    required this.accountNumber,
    required this.beneficiaryName,
    this.methodType = 'wallet',
    this.methodColor = const Color(0xFFDF146E),
  });

  factory PayoutReviewArgs.fromQuery(Map<String, String> query) {
    return PayoutReviewArgs(
      amount: double.tryParse(query['amount'] ?? '0') ?? 0.0,
      methodName: query['methodName'] ?? 'Bkash',
      accountNumber: query['account'] ?? '',
      beneficiaryName: query['name'] ?? '',
      methodType: query['type'] ?? 'wallet',
    );
  }
}

class PayoutSuccessArgs {
  final double amount;
  final String methodName;
  final String accountNumber;
  final String transactionId;
  final String dateTime;

  const PayoutSuccessArgs({
    required this.amount,
    required this.methodName,
    required this.accountNumber,
    required this.transactionId,
    required this.dateTime,
  });

  factory PayoutSuccessArgs.fromQuery(Map<String, String> query) {
    return PayoutSuccessArgs(
      amount: double.tryParse(query['amount'] ?? '0') ?? 0.0,
      methodName: query['methodName'] ?? '',
      accountNumber: query['account'] ?? '',
      transactionId: query['txnId'] ?? '',
      dateTime: query['date'] ?? '',
    );
  }
}

class ResetPasswordArgs {
  final String email;
  final String code;

  const ResetPasswordArgs({required this.email, required this.code});
}
