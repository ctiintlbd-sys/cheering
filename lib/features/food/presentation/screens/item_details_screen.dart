import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';
import 'package:cheering/features/food/presentation/screens/widgets/item_size_options_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/item_add_ons_widget.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  int _selectedSizeIndex = 1;
  final Map<int, bool> _selectedAddOns = {0: true, 1: false};

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ViewCartButton(
        itemCount: 1,
        totalPrice: 650,
        onTap: () {},
      ),
      appBar: CustomSliverAppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.w),
          child: CommonActionIcon(
            icon: Assets.icons.arrowBack.path,
            onTap: () => context.pop(),
          ),
        ),
        expandedHeight: 210.w,
        collapsedTitle: 'Fried Chicken Bucket',
        flexibleBackground: CustomNetworkImage(
          height: 280.w,
          imageUrl:
              'https://images.unsplash.com/photo-1513104890138-7c749659a591',
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
        ],
      ),
      bodyList: [
        CustomText(
          text: 'Fried Chicken Bucket',
          fontSize: 20.r,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.w),
        CustomText(
          text:
              '8 pieces of our signature crispy fried chicken, marinated for 24 hours in a secret spice blend.',
          fontSize: 12.r,
          color: context.colors.textSecondary,
        ),
        ItemSizeOptionsWidget(
          selectedIndex: _selectedSizeIndex,
          onChanged: (index) {
            setState(() {
              _selectedSizeIndex = index;
            });
          },
        ),
        ItemAddOnsWidget(
          selectedAddOns: _selectedAddOns,
          onToggle: (index) {
            setState(() {
              _selectedAddOns[index] = !(_selectedAddOns[index] ?? false);
            });
          },
        ),
        SizedBox(height: 120.w),
      ],
    );
  }
}
