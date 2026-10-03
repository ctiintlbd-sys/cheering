import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/domain/entities/delivery_option_entity.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/delivery_mode_toggle_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/tip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryOrTipSection extends StatefulWidget {
  const DeliveryOrTipSection({
    super.key,
    required this.deliveryOptions,
    required this.selectedTip,
    required this.onTipSelected,
  });

  final List<DeliveryOptionEntity> deliveryOptions;
  final double selectedTip;
  final ValueChanged<double> onTipSelected;

  @override
  State<DeliveryOrTipSection> createState() => _DeliveryOrTipSectionState();
}

class _DeliveryOrTipSectionState extends State<DeliveryOrTipSection> {
  final ValueNotifier<int> _deliveryTypeNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _deliveryTypeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radiusAll: 16.r,
      color: context.colors.white,
      horizontalMargin: 16.w,
      child: ValueListenableBuilder<int>(
        valueListenable: _deliveryTypeNotifier,
        builder: (context, deliveryTypeIndex, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(12.r),
                child: DeliveryModeToggleWidget(
                  selectedIndex: deliveryTypeIndex,
                  options: const ['Delivery', 'Tip'],
                  showIcons: false,
                  onChanged: (index) {
                    _deliveryTypeNotifier.value = index;
                  },
                ),
              ),
              SizedBox(height: 4.w),
              if (deliveryTypeIndex == 0)
                ...widget.deliveryOptions.map(
                  (option) => CustomContainer(
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
                          borderWidth: option.isSelected ? 6 : 1.5,
                          bordersColor: option.isSelected
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
                            text:
                                '+${option.extraFee.toStringAsFixed(2)}',
                            color: context.colors.textSecondary,
                          ),
                        const Spacer(),
                        CustomText(
                          text:
                              '${option.etaMinMinutes}-${option.etaMaxMinutes} min',
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                )
              else
                TipWidget(
                  selectedTip: widget.selectedTip,
                  onTipSelected: widget.onTipSelected,
                ),
              SizedBox(height: 12.w),
            ],
          );
        },
      ),
    );
  }
}
