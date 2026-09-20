import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoCodeCard extends StatelessWidget {
  const PromoCodeCard({
    super.key,
    required this.items,
    required this.onSelected,
  });

  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomMenuContainer(
        items: items,
        onSelected: onSelected,
        child: CustomContainer(
          radiusAll: 12.r,
          paddingAll: 16.r,
          color: context.colors.background,
          boxShadow: [
            BoxShadow(
              color: context.colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          child: Row(
            children: [
              Assets.icons.promo.svg(),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomText(
                  text: 'Apply Promo',
                  fontSize: 14.r,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              Icon(Icons.chevron_right, color: context.colors.textPlaceholder),
            ],
          ),
        ),
      ),
    );
  }
}
