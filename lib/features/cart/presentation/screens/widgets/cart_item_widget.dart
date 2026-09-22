import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/entities/add_cart_item_params.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final Function(AddCartItemParams) onUpdateItem;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onUpdateItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNetworkImage(
          borderRadius: 12.r,
          imageUrl: item.imageUrl ?? '',
          width: 66.w,
          height: 66.w,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: item.name,
                fontWeight: FontWeight.w600,
                maxLines: 1,
              ),
              if (item.variantName != null || item.addOnNames.isNotEmpty)
                CustomText(
                  top: 2.w,
                  text: [
                    if (item.variantName != null) item.variantName,
                    if (item.addOnNames.isNotEmpty) item.addOnNames.join(', '),
                  ].join(' · '),
                  fontSize: 12.r,
                  color: context.colors.textTertiary,
                  maxLines: 1,
                  bottom: 2.w,
                ),
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: '৳${item.unitPrice.toStringAsFixed(0)}',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  QuantityButton(
                    count: item.quantity,
                    onIncrement: () {
                      onUpdateItem(
                        AddCartItemParams(
                          menuItemId: item.menuItemId,
                          variantId: item.variantId,
                          addOnIds: item.addOnIds,
                          quantity: item.quantity + 1,
                          notes: item.notes,
                        ),
                      );
                    },
                    onDecrement: () {
                      onUpdateItem(
                        AddCartItemParams(
                          menuItemId: item.menuItemId,
                          variantId: item.variantId,
                          addOnIds: item.addOnIds,
                          quantity: item.quantity - 1,
                          notes: item.notes,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
