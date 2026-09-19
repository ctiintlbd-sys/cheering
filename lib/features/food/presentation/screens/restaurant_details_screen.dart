import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_item_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/restaurant_details_header.dart';
import 'package:cheering/features/food/presentation/screens/widgets/restaurant_app_bar_bottom.dart';
import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: CommonActionIcon(
            icon: Assets.icons.arrowBack.path,
            onTap: () => context.pop(),
          ),
        ),
        expandedHeight: 416.h,
        flexibleBackground: _buildFlexibleBackground(),
        actions: [CommonDetailsActions(onShareTap: () {}, onLoveTap: () {})],
        bottom: RestaurantAppBarBottom(),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ViewCartButton(
        itemCount: 1,
        totalPrice: 650,
        onTap: () {},
      ),
      bodyList: _buildMenuBody(),
    );
  }

  Widget _buildFlexibleBackground() {
    return Stack(
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
          child: RestaurantDetailsHeader(),
        ),
      ],
    );
  }

  List<Widget> _buildMenuBody() {
    return [
      SizedBox(height: 20.h),
      CustomText(
        text: 'Pizza',
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ).horizontal(16.w),
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

      SizedBox(height: 140.h),
    ];
  }
}
