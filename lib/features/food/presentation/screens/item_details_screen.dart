import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/item_size_options_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/item_add_ons_widget.dart';

import 'package:cheering/features/cart/domain/entities/add_cart_item_params.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';

import 'package:cheering/features/food/presentation/blocs/item_details/item_details_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/item_details/item_details_event.dart';
import 'package:cheering/features/food/presentation/blocs/item_details/item_details_state.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.menuItem});

  final MenuItemEntity menuItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
      builder: (context, state) {
        return SliverScaffold(
          sideContentPadding: 16.w,
          appBar: CustomSliverAppBar(
            leading: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.w),
              child: CommonActionIcon(
                icon: Assets.icons.arrowBack.path,
                onTap: () => context.pop(),
              ),
            ),
            expandedHeight: 210.w,
            collapsedTitle: menuItem.name,
            flexibleBackground: CustomNetworkImage(
              height: 280.w,
              imageUrl: menuItem.imageUrl,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                height: 32.w,
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
              ),
            ),
            actions: [
              CommonActionIcon(icon: Assets.icons.foodShare.path, onTap: () {}),
              SizedBox(width: 16.w),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildBottomBar(context, state),
          bodyList: [
            CustomText(
              text: menuItem.name,
              fontSize: 20.r,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.w),
            if (menuItem.description != null && menuItem.description!.isNotEmpty)
              CustomText(
                text: menuItem.description!,
                fontSize: 12.r,
                color: context.colors.textSecondary,
              ),
            
            if (menuItem.variants != null && menuItem.variants!.isNotEmpty)
              ItemSizeOptionsWidget(
                variants: menuItem.variants!,
                selectedIndex: state.selectedVariant != null 
                    ? menuItem.variants!.indexOf(state.selectedVariant!) 
                    : -1,
                onChanged: (index) {
                  context.read<ItemDetailsBloc>().add(
                    SelectVariantEvent(menuItem.variants![index])
                  );
                },
              ),
              
            if (menuItem.addOns != null && menuItem.addOns!.isNotEmpty)
              ItemAddOnsWidget(
                addOns: menuItem.addOns!,
                selectedAddOns: Map.fromEntries(
                  menuItem.addOns!.asMap().entries.map(
                    (e) => MapEntry(e.key, state.selectedAddOns.contains(e.value))
                  )
                ),
                onToggle: (index) {
                  context.read<ItemDetailsBloc>().add(
                    ToggleAddOnEvent(menuItem.addOns![index])
                  );
                },
              ),
              
            SizedBox(height: 120.w),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ItemDetailsState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomContainer(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuantityButton(
              count: state.quantity,
              onIncrement: () {
                context.read<ItemDetailsBloc>().add(IncrementQuantityEvent());
              },
              onDecrement: () {
                context.read<ItemDetailsBloc>().add(DecrementQuantityEvent());
              },
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<CartBloc>().add(
                    AddOrUpdateCartItemEvent(
                      AddCartItemParams(
                        menuItemId: menuItem.id,
                        quantity: state.quantity,
                        variantId: state.selectedVariant?.id,
                        addOnIds: state.selectedAddOns.map((a) => a.id).toList(),
                      ),
                    ),
                  );
                  context.pop();
                },
                child: CustomContainer(
                  color: context.colors.primary,
                  radiusAll: 99.r,
                  paddingVertical: 14.w,
                  alignment: Alignment.center,
                  child: CustomText(
                    text: 'Add to cart · ৳${state.totalPrice.toStringAsFixed(0)}',
                    color: context.colors.white,
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
