import 'package:cheering/features/food/domain/entities/menu_entity.dart';
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
  const ItemDetailsScreen({super.key, required this.menuItem});

  final MenuItemEntity menuItem;

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
        collapsedTitle: widget.menuItem.name,
        flexibleBackground: CustomNetworkImage(
          height: 280.w,
          imageUrl: widget.menuItem.imageUrl,
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
          text: widget.menuItem.name,
          fontSize: 20.r,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.w),
        if (widget.menuItem.description != null &&
            widget.menuItem.description!.isNotEmpty)
          CustomText(
            text: widget.menuItem.description!,
            fontSize: 12.r,
            color: context.colors.textSecondary,
          ),
        if (widget.menuItem.variants != null &&
            widget.menuItem.variants!.isNotEmpty)
          ItemSizeOptionsWidget(
            variants: widget.menuItem.variants!,
            selectedIndex: _selectedSizeIndex,
            onChanged: (index) {
              setState(() {
                _selectedSizeIndex = index;
              });
            },
          ),
        if (widget.menuItem.variants != null &&
            widget.menuItem.variants!.isNotEmpty)
          ItemAddOnsWidget(
            addOns: widget.menuItem.addOns!,
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
