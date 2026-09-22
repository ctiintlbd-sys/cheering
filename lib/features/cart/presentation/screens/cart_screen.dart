import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/bill_details_card.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/cart_botton_bar_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/cart_item_container.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/cart_loading_shimmer.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/delivery_mode_toggle_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/promo_code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return SliverScaffold(
          isNavWrap: false,
          backgroundColor: context.colors.bgSecondary,
          appBar: CustomSliverAppBar(
            backgroundColor: context.colors.bgSecondary,
            title: 'Your cart',
            flexibleChild: const SizedBox.shrink(),
            expandedHeight: 110.w,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40.w),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0.w,
                  horizontal: 16.w,
                ),
                child: DeliveryModeToggleWidget(
                  selectedIndex: selectedIndex,
                  onChanged: (int value) {
                    selectedIndex = value;
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          bottomNavigationBar: state.cart?.items != null && state.cart!.items.isNotEmpty
              ? CartBottomBarWidget(totalPrice: state.cart!.itemTotal)
              : const SizedBox.shrink(),
          bodyList: switch (state.status) {
            CartStatus.initial ||
            CartStatus.loading => [
              SizedBox(height: 16.w),
              const CartLoadingShimmer(),
              SizedBox(height: 204.w),
            ],
            CartStatus.failure => [
              SizedBox(height: 16.w),
              EmptyState(
                message: state.errorMessage ?? 'Something went wrong',
              ),
              SizedBox(height: 204.w),
            ],
            CartStatus.success when state.cart == null || state.cart!.items.isEmpty => [
              SizedBox(height: 16.w),
              const EmptyState(message: 'Your cart is empty'),
              SizedBox(height: 204.w),
            ],
            CartStatus.success => [
              SizedBox(height: 16.w),
              CartItemContainer(
                cart: state.cart!,
                onUpdateItem: (params) {
                  context.read<CartBloc>().add(AddOrUpdateCartItemEvent(params));
                },
              ),
              SizedBox(height: 20.w),
              PromoCodeCard(items: const [], onSelected: (String value) {}),
              SizedBox(height: 24.w),
              BillDetailsCard(
                itemTotal: state.cart!.itemTotal,
                itemCount: state.cart!.itemCount,
                minOrderAmount: state.cart!.minOrderAmount,
              ),
              SizedBox(height: 204.w),
            ],
          },
        );
      },
    );
  }
}
