import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/domain/entities/delivery_option_entity.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/delivery_mode_toggle_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/delivery_options_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/tip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryOrTipSection extends StatefulWidget {
  const DeliveryOrTipSection({
    super.key,
    required this.deliveryOptions,
    required this.selectedTip,
    required this.onTipSelected,
    this.selectedDeliveryType,
    this.onDeliveryOptionSelected,
  });

  final List<DeliveryOptionEntity> deliveryOptions;
  final double selectedTip;
  final ValueChanged<double> onTipSelected;
  final String? selectedDeliveryType;
  final ValueChanged<DeliveryOptionEntity>? onDeliveryOptionSelected;

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
                DeliveryOptionsWidget(
                  deliveryOptions: widget.deliveryOptions,
                  selectedDeliveryType: widget.selectedDeliveryType,
                  onDeliveryOptionSelected: widget.onDeliveryOptionSelected,
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
