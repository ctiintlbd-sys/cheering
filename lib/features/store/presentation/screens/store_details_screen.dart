import 'package:cheering/core/common_widgets/custom_filter_chip.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_category_tabs.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_item_widget.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_details_header.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_reviews_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  bool _showReviews = false;

  void _toggleReviews() => setState(() => _showReviews = !_showReviews);

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showReviews
          ? null
          : ViewCartButton(itemCount: 1, totalPrice: 650, onTap: () {}),
      appBar: CustomSliverAppBar(
        leading: Padding(
          padding:  EdgeInsets.symmetric(vertical: 6.h),
          child: _buildActionIcon(context, Assets.icons.arrowBack.path, () {
            context.pop();
          }),
        ),
        expandedHeight:  416.h,
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
              child: StoreDetailsHeader(
                isExpanded: _showReviews,
                onTap: _toggleReviews,
              ),
            ),
          ],
        ),
        actions: [
          _buildActionIcon(context, Assets.icons.foodShare.path, () {}),
          SizedBox(width: 8.w),
          _buildActionIcon(context, Assets.icons.foodLove.path, () {}),
          SizedBox(width: 16.w),
        ],
        bottom: _showReviews ? null : _buildMenuSearchBar(context),
      ),
      bodyList: _showReviews ? _buildReviewsBody() : _buildMenuBody(),
    );
  }

  PreferredSize _buildMenuSearchBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(78.h),
      child: _showReviews ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
              CustomFilterChip(
                label: 'All',
                isSelected: true,
                onTap: () {},
              ),

          ],
        ),
      ) : CustomContainer(
        topLeftRadius: 32.r,
        topRightRadius: 32.r,
        color: context.colors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomTextField(
                validator: (_) => null,
                contentPaddingVertical: 12.h,
                hintText: 'Search Menu',
                prefixIcon: Assets.icons.search.svg(),
                fillColor: context.colors.bgSecondary,
                borderColor: context.colors.background,
                borderRadius: 99.r,
              ),
            ),

            SizedBox(height: 20.h),
            const MenuCategoryTabs(),
          ],
        ),
      ),
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

  List<Widget> _buildReviewsBody() {
    return [
      SizedBox(height: 20.h),
      SliverList.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          return CustomItemAnimator(
            index: index,
            animationType: CustomItemAnimationType.slide,
            child: ReviewCardWidget(),
          );
        },
      ),

      SizedBox(height: 140.h),
    ];
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
