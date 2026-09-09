import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_item_widget.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_details_header.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_reviews_view.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_app_bar_bottom.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_details_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';
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
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: StoreActionIcon(
            icon: Assets.icons.arrowBack.path,
            onTap: () {
              context.pop();
            },
          ),
        ),
        expandedHeight: _showReviews ? 458.h : 416.h,
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
        actions: [StoreDetailsActions(onShareTap: () {}, onLoveTap: () {})],
        bottom: StoreAppBarBottom(showReviews: _showReviews),
      ),
      bodyList: _showReviews ? _buildReviewsBody() : _buildMenuBody(),
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
}
