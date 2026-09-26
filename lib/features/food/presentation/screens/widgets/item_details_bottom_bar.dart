import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/domain/entities/add_cart_item_params.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/food/presentation/blocs/item_details/item_details_state.dart';
import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
              addOnIds,
            ) ??
            0;
        void updateQuantity(int quantity) {
          context.read<CartBloc>().add(
            AddOrUpdateCartItemEvent(
              AddCartItemParams(
                menuItemId: menuItem.id,
                quantity: quantity,
                variantId: state.selectedVariant?.id,
                addOnIds: addOnIds,
              ),
            ),
          );
        }

        return Row(
          children: [

            Expanded(
              child: CustomButton(
                onPressed: () => context.push(RoutePaths.cart),
                label: 'View cart',
              ),
            ),
            SizedBox(width: 24.w),
            QuantityButton(
              count: count,
              onIncrement: () => updateQuantity(count + 1),
              onDecrement: () {
                if (count > 0) updateQuantity(count - 1);
              },
            ),
            SizedBox(width: 16.w),
          ],
        );
      },
    );
  }
}
