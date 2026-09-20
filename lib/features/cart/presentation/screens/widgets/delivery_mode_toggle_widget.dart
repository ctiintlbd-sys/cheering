import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryModeToggleWidget extends StatelessWidget {
  const DeliveryModeToggleWidget({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.options = const ['Delivery', 'Pickup'],
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> options;

  Alignment _getAlignment(int index, int total) {
    if (total == 1) return Alignment.center;
    final step = 2 / (total - 1);
    return Alignment(-1 + index * step, 0);
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 40.r,
      color: context.colors.bgTertiary,
      radiusAll: 99.r,
      paddingAll: 2.r,
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _getAlignment(selectedIndex, options.length),
            child: FractionallySizedBox(
              widthFactor: 1 / options.length,
              heightFactor: 1,
              child: CustomContainer(
                radiusAll: 99.r,
                color: context.colors.background,
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: List.generate(options.length, (index) {
                final isSelected = index == selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(index),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            index == 1
                                ? Icons.directions_walk
                                : Icons.directions_bike,
                            color: isSelected
                                ? context.colors.textPrimary
                                : context.colors.textSecondary,
                            size: 20.r,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: options[index],
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? context.colors.textPrimary
                                : context.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
