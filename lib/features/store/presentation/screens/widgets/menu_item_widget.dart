import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:cheering/features/cart/domain/entities/add_cart_item_params.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/router/app_router_notifier.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemEntity? menuItem;

  const MenuItemWidget({super.key, this.menuItem});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = getIt<AppRouterNotifier>().isAuthenticated;
    final hasVariants = menuItem?.variants?.isNotEmpty ?? false;
    final hasAddOns = menuItem?.addOns?.isNotEmpty ?? false;
    final hasOptions = hasVariants || hasAddOns;

    return GestureDetector(
      onTap: () {
        if (isLoggedIn && hasOptions) {
          context.push(RoutePaths.itemDetails, extra: menuItem);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              width: 66.r,
              height: 66.r,
              borderRadius: 12.r,
              imageUrl: menuItem?.imageUrl,
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: menuItem?.name ?? '',
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    bottom: 2.w,
                  ),
                  if (menuItem?.description != null &&
                      menuItem!.description!.isNotEmpty)
                    CustomText(
                      text: menuItem!.description!,
                      color: context.colors.textTertiary,
                      fontSize: 12.r,
                      maxLines: 1,
                    ),
                  SizedBox(height: 8.w),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text:
                            '৳${menuItem?.basePrice.toStringAsFixed(0) ?? '0'}',
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.r,
                      ),

                      if (menuItem != null)
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            final count =
                                state.cart?.quantityFor(menuItem!.id) ?? 0;
                            return QuantityButton(
                              count: count,
                              onIncrement: () {
                                if (hasOptions) {
                                  context.push(
                                    RoutePaths.itemDetails,
                                    extra: menuItem,
                                  );
                                } else {
                                  context.read<CartBloc>().add(
                                    AddOrUpdateCartItemEvent(
                                      AddCartItemParams(
                                        menuItemId: menuItem!.id,
                                        quantity: count + 1,
                                      ),
                                    ),
                                  );
                                }
                              },
                              onDecrement: () {
                                if (count > 0) {
                                  context.read<CartBloc>().add(
                                    AddOrUpdateCartItemEvent(
                                      AddCartItemParams(
                                        menuItemId: menuItem!.id,
                                        quantity: count - 1,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
