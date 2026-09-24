import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/data/models/payment_method_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodsCard extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const PaymentMethodsCard({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radiusAll: 16.r,
      horizontalMargin: 16.w,
      color: context.colors.background,
      child: Column(
        children: List.generate(PaymentMethodItem.options.length, (index) {
          final item = PaymentMethodItem.options[index];
          final isSelected = item.backendValue == selectedValue;

          return GestureDetector(
            onTap: () => onChanged(item.backendValue),
            behavior: HitTestBehavior.opaque,
            child: CustomContainer(
              paddingAll: 16.w,
              border: index != PaymentMethodItem.options.length - 1
                  ? Border(
                      bottom: BorderSide(color: context.colors.borderTertiary),
                    )
                  : null,
              child: Row(
                children: [
                  item.icon,
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: item.title,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: item.subtitle,
                          color: index == 0
                              ? context.colors.primary
                              : context.colors.textSecondary,
                          fontSize: 12.r,
                        ),
                      ],
                    ),
                  ),
                  CustomContainer(
                    width: 20.r,
                    height: 20.r,
                    shape: BoxShape.circle,
                    color: context.colors.white,
                    borderWidth: isSelected ? 6 : 2,
                    bordersColor: isSelected
                        ? context.colors.primary
                        : context.colors.borderSecondary,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
