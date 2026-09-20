import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/bill_details_card.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/cart_botton_bar_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/cart_item_container.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/delivery_mode_toggle_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/promo_code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      isNavWrap: false,
      backgroundColor: context.colors.bgSecondary,
      appBar: CustomSliverAppBar(
        backgroundColor: context.colors.bgSecondary,
        title: 'Your cart',
        flexibleChild: SizedBox.shrink(),
        expandedHeight: 110.w,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.w),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.w, horizontal: 16.w),
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
      bottomNavigationBar: const CartBottomBarWidget(totalPrice: 1201),
      bodyList: [
        SizedBox(height: 16.w),
        const CartItemContainer(),
        SizedBox(height: 20.w),
        PromoCodeCard(items: [], onSelected: (String value) {}),
        SizedBox(height: 24.w),
        const BillDetailsCard(),
        SizedBox(height: 204.w),
      ],
    );
  }
}
