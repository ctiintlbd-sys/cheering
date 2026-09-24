import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/cart/domain/entities/add_cart_item_params.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';
import 'package:cheering/features/food/presentation/blocs/item_details/item_details_state.dart';

class ItemDetailsBottomBar extends StatelessWidget {
  const ItemDetailsBottomBar({
    super.key,
    required this.menuItem,
    required this.state,
  });

  final MenuItemEntity menuItem;
  final ItemDetailsState state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final addOnIds = state.selectedAddOns.map((a) => a.id).toList();
        final count = cartState.cart?.quantityForConfiguration(
          menuItem.id, 
          state.selectedVariant?.id, 
          addOnIds
        ) ?? 0;
        
        final displayQuantity = count > 0 ? count : 1;
        final displayTotal = state.unitPrice * displayQuantity;

        return CustomContainer(
          radiusAll: 12.r,
          paddingHorizontal: 12.w,
          paddingVertical: 8.w,
          color: context.colors.background,
          boxShadow: [
            BoxShadow(
              color: context.colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Total: ৳${displayTotal.toStringAsFixed(0)}',
                fontWeight: FontWeight.w700,
                fontSize: 16.r,
                color: context.colors.primary,
              ),
              QuantityButton(
                count: count,
                onIncrement: () {
                  context.read<CartBloc>().add(
                    AddOrUpdateCartItemEvent(
                      AddCartItemParams(
                        menuItemId: menuItem.id,
                        quantity: count + 1,
                        variantId: state.selectedVariant?.id,
                        addOnIds: state.selectedAddOns.map((a) => a.id).toList(),
                      ),
                    ),
                  );
                },
                onDecrement: () {
                  if (count > 0) {
                    context.read<CartBloc>().add(
                      AddOrUpdateCartItemEvent(
                        AddCartItemParams(
                          menuItemId: menuItem.id,
                          quantity: count - 1,
                          variantId: state.selectedVariant?.id,
                          addOnIds: state.selectedAddOns.map((a) => a.id).toList(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
