import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/item_size_options_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/item_add_ons_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/item_details_bottom_bar.dart';
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
              width: 1.sw,
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
          bottomNavigationBar: ItemDetailsBottomBar(
            menuItem: menuItem,
            state: state,
          ),
          bodyList: [
            CustomText(
              text: menuItem.name,
              fontSize: 20.r,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.w),
            if (menuItem.description != null &&
                menuItem.description!.isNotEmpty)
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
                    SelectVariantEvent(menuItem.variants![index]),
                  );
                },
              ),

            if (menuItem.addOns != null && menuItem.addOns!.isNotEmpty)
              ItemAddOnsWidget(
                addOns: menuItem.addOns!,
                selectedAddOns: state.selectedAddOns,
                onToggle: (addOn) {
                  context.read<ItemDetailsBloc>().add(ToggleAddOnEvent(addOn));
                },
              ),

            SizedBox(height: 120.w),
          ],
        );
      },
    );
  }
}
