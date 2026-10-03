import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/entities/add_cart_item_params.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'cart_item_widget.dart';

class CartItemContainer extends StatelessWidget {
  final CartEntity cart;
  final Function(AddCartItemParams)? onUpdateItem;

  const CartItemContainer({
    super.key,
    required this.cart,
    this.onUpdateItem,
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
              CustomText(
                text: '${cart.itemCount} Items',
                color: context.colors.textSecondary,
              ),
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
              final item = cart.items[index];
              return CustomItemAnimator(
                index: index,
                child: CartItemWidget(
                  item: item,
                  onIncrement: () {
                    context.read<CartBloc>().add(
                      UpdateCartLineQuantityEvent(
                        lineId: item.lineId,
                        quantity: item.quantity + 1,
                      ),
                    );
                  },
                  onDecrement: () {
                    context.read<CartBloc>().add(
                      UpdateCartLineQuantityEvent(
                        lineId: item.lineId,
                        quantity: item.quantity - 1,
                      ),
                    );
                  },
                  onUpdateAddOnQuantity: (addOnId, quantity) {
                    context.read<CartBloc>().add(
                      UpdateCartAddOnQuantityEvent(
                        item: item,
                        addOnId: addOnId,
                        quantity: quantity,
                      ),
                    );
                  },
                  onRemove: () {
                    context.read<CartBloc>().add(
                      RemoveCartItemEvent(lineId: item.lineId),
                    );
                  },
                ),
              );
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
              onPressed: () {
                if (cart.restaurantId != null) {
                  final dummyRestaurant = RestaurantEntity.stub(
                    id: cart.restaurantId!,
                    name: cart.restaurantName ?? '',
                    minOrderAmount: cart.minOrderAmount,
                    isOpen: cart.restaurantIsOpen,
                  );
                  context.push(
                    RoutePaths.storeDetails(dummyRestaurant.id),
                    extra: dummyRestaurant,
                  );
                }
              },
              label: 'Add more items',
            ),
          ),
        ],
      ),
    );
  }
}
