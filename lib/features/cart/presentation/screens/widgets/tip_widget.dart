import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TipWidget extends StatefulWidget {
  const TipWidget({
    super.key,
    required this.selectedTip,
    required this.onTipSelected,
  });

  final double selectedTip;
  final ValueChanged<double> onTipSelected;

  @override
  State<TipWidget> createState() => _TipWidgetState();
}

class _TipWidgetState extends State<TipWidget> {
  bool saveForNextOrder = true;

  final List<double> tipOptions = [0, 10, 20, 30, 40, 50, 100];

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Assets.icons.tip.svg(),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Tip to your rider',
                        fontSize: 16.r,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: '100% tip goes right to the rider.',
                        fontSize: 12.r,
                        color: context.colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tipOptions.map((tipAmount) {
                final isSelected = widget.selectedTip == tipAmount;
                final text = tipAmount == 0 ? 'Not now' : '৳${tipAmount.toInt()}';
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () => widget.onTipSelected(tipAmount),
                    child: CustomContainer(
                      paddingHorizontal: 10.w,
                      paddingVertical: 8.w,
                      radiusAll: 99.r,
                      color: isSelected ? context.colors.primary : context.colors.background,
                      bordersColor: isSelected ? context.colors.primary : context.colors.borderSecondary,
                      child: CustomText(
                        text: text,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.w,
                        color: isSelected ? context.colors.white : context.colors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
