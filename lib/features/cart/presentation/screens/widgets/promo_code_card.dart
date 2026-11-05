import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/promotion_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoCodeCard extends StatelessWidget {
  const PromoCodeCard({
    super.key,
    required this.promotions,
    required this.onSelected,
    this.selectedCode,
  });

  final List<PromotionEntity> promotions;
  final ValueChanged<String> onSelected;
  final String? selectedCode;

  @override
  Widget build(BuildContext context) {
    final promoItems = promotions.map((p) => p.displayDiscount).toList();
    final selectedPromo =
        promotions.where((p) => p.code == selectedCode).firstOrNull;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomMenuContainer(
        items: promoItems,
        onSelected: (value) {
          final index = promoItems.indexOf(value);
          final code = index != -1 ? promotions[index].code : value;
          onSelected(code);
        },
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
                  text: selectedPromo?.displayDiscount ?? 'Apply Promo',
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
