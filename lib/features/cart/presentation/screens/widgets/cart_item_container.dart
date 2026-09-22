import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/entities/add_cart_item_params.dart';

class CartItemContainer extends StatelessWidget {
  final CartEntity cart;
  final Function(AddCartItemParams) onUpdateItem;

  const CartItemContainer({
    super.key,
    required this.cart,
    required this.onUpdateItem,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      horizontalMargin: 16.w,
      paddingAll: 12.r,
      radiusAll: 12.r,
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.03),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
      color: context.colors.background,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: cart.restaurantName ?? 'Restaurant',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              CustomText(text: '${cart.itemCount} Items', color: context.colors.textSecondary),
            ],
          ),
          SizedBox(height: 16.w),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: cart.items.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.w),
            itemBuilder: (context, index) {
              return _buildCartItem(context: context, item: cart.items[index]);
            },
          ),
          SizedBox(height: 18.w),

          DottedBorderWidget(
            child: CustomButton(
              backgroundColor: Colors.transparent,
              fontSize: 14.w,
              fontWeight: FontWeight.w600,
              borderRadius: 12.r,
              prefixIcon: Icon(
                Icons.add,
                color: context.colors.primary,
                size: 14.r,
              ),
              foregroundColor: context.colors.primary,
              onPressed: () {},
              label: 'Add more items',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({required BuildContext context, required CartItemEntity item}) {
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
