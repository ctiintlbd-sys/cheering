import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodItem {
  final String title;
  final String subtitle;
  final String backendValue;
  final Widget icon;

  const PaymentMethodItem({
    required this.title,
    required this.subtitle,
    required this.backendValue,
    required this.icon,
  });

  static List<PaymentMethodItem> options = [
    PaymentMethodItem(
      title: 'Cash on delivery',
      subtitle: 'Pay when your order arrives',
      backendValue: 'COD',
      icon: Assets.images.cash.image(height: 24.w,width: 24.w),
    ),
    PaymentMethodItem(
      title: 'bKash',
      subtitle: '01XXX-XXXXXX',
      backendValue: 'BKASH',
      icon: Assets.icons.bikash.svg(),
    ),
    PaymentMethodItem(
      title: 'Visa/Mastercard',
      subtitle: 'Visa •••• 4242',
      backendValue: 'CARD',
      icon: Assets.icons.visa.svg(),
    ),
  ];
}
