import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/domain/entities/delivery_option_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryOptionsWidget extends StatelessWidget {
  const DeliveryOptionsWidget({
    super.key,
    required this.deliveryOptions,
    this.onDeliveryOptionSelected,
    this.selectedDeliveryType,
  });

  final List<DeliveryOptionEntity> deliveryOptions;
  final ValueChanged<DeliveryOptionEntity>? onDeliveryOptionSelected;
  final String? selectedDeliveryType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: deliveryOptions.map((option) {
        final isSelected = selectedDeliveryType != null
            ? option.type == selectedDeliveryType
            : option.isSelected;

        return GestureDetector(
          onTap: () => onDeliveryOptionSelected?.call(option),
          behavior: HitTestBehavior.opaque,
          child: CustomContainer(
            horizontalMargin: 12.w,
            paddingVertical: 12.w,
            paddingHorizontal: 16.w,
            child: Row(
              children: [
                CustomContainer(
                  width: 20.r,
                  height: 20.r,
                  shape: BoxShape.circle,
                  color: context.colors.white,
                  borderWidth: isSelected ? 6 : 1.5,
                  bordersColor: isSelected
                      ? context.colors.primary
                      : context.colors.borderPrimary,
                ),
                SizedBox(width: 12.w),
                CustomText(
                  text: option.label,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(width: 8.w),
                if (option.extraFee > 0)
                  CustomText(
                    text: '+${option.extraFee.toStringAsFixed(2)}',
                    color: context.colors.textSecondary,
                  ),
                const Spacer(),
                CustomText(
                  text: '${option.etaMinMinutes}-${option.etaMaxMinutes} min',
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
