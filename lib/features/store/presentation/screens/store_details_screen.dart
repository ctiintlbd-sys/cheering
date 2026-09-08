import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_category_tabs.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_item_widget.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreDetailsScreen extends StatelessWidget {
  const StoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ViewCartButton(
        itemCount: 1,
        totalPrice: 650,
        onTap: () {},
      ),
      appBar: CustomSliverAppBar(
        toolbarHeight: kToolbarHeight + 6.h,
        leading: IconButton(
          onPressed: () {},
          icon: _buildActionIcon(context, Assets.icons.arrowBack.path, () {}),
        ),
        expandedHeight: 394.h,
        flexibleBackground: Stack(
          children: [
            CustomNetworkImage(
              height: 220.h,
              imageUrl:
                  'https://images.unsplash.com/photo-1513104890138-7c749659a591',
            ),

            Positioned(
              top: 190.h,
              right: 0,
              left: 0,
              child: const StoreDetailsHeader(),
            ),
          ],
        ),
        actions: [
          _buildActionIcon(context, Assets.icons.foodShare.path, () {}),
          SizedBox(width: 8.w),
          _buildActionIcon(context, Assets.icons.foodLove.path, () {}),
          SizedBox(width: 16.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(52.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextField(
                  hintText: 'Search Menu',
                  prefixIcon: Assets.icons.search.svg(),
                  fillColor: context.colors.background,
                  borderColor: context.colors.borderSecondary,
                  borderRadius: 99.r,
                ),
              ),

              SizedBox(height: 12.h),
              const MenuCategoryTabs(),
            ],
          ),
        ),
      ),
      bodyList: [
        // Section Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: 'Pizza',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),

        // Menu Items
        SliverList.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return CustomItemAnimator(
              index: index,
              animationType: CustomItemAnimationType.slide,
              child: MenuItemWidget(index: index),
            );
          },
        ),

        SizedBox(height: 100.h), // Padding for Floating button
      ],
    );
  }

  Widget _buildActionIcon(
    BuildContext context,
    String icon,
    VoidCallback onTap,
  ) {
    return CustomContainer(
      onTap: onTap,
      paddingAll: 10.r,
      shape: BoxShape.circle,
      color: context.colors.white,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        icon,
        height: 24.r,
        width: 24.r,
        colorFilter: ColorFilter.mode(
          context.colors.textPrimary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
