import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';

import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';

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
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: CommonActionIcon(
            icon: Assets.icons.arrowBack.path,
            onTap: () => context.pop(),
          ),
        ),
        expandedHeight: 210.h,
        flexibleBackground: CustomNetworkImage(
          height: 280.h,
          imageUrl:
              'https://images.unsplash.com/photo-1513104890138-7c749659a591',
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24),
          child: Container(
            height: 32.h,
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
            ),
          ),
        ),
        actions: [CommonDetailsActions(onShareTap: () {}, onLoveTap: () {})],
      ),
      bodyList: [
        CustomText(
          text: 'Fried Chicken Bucket',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.h),
        CustomText(
          text:
              '8 pieces of our signature crispy fried chicken, marinated for 24 hours in a secret spice blend.',
          fontSize: 12.sp,
          color: context.colors.textSecondary,
        ),
        CustomText(
          top: 24.sp,
          text: 'Choose size',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: context.colors.textTertiary,
        ),
        _buildSizeOptions(),
        _buildSectionTitle('Add-ons'),
        _buildAddOns(),
        SizedBox(height: 120.h),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      top: 24.sp,
      text: title,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: context.colors.textTertiary,
    );
  }

  Widget _buildSizeOptions() {
    return CustomContainer(
      verticalMargin: 12.h,
      radiusAll: 16.r,
      bordersColor: context.colors.borderSecondary,
      child: Column(
        children: [
          _buildSizeOptionTile(
            index: 0,
            title: '6 pcs',
            subtitle: 'Serves 1-2',
            isFirst: true,
          ),
          Divider(height: 1, color: context.colors.borderSecondary),
          _buildSizeOptionTile(
            index: 1,
            title: '8 pcs',
            subtitle: 'Serves 2-3 · Most popular',
          ),
          Divider(height: 1, color: context.colors.borderSecondary),
          _buildSizeOptionTile(
            index: 2,
            title: '12 pcs',
            subtitle: 'Serves 3-4',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOptionTile({
    required int index,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = _selectedSizeIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selectedSizeIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: subtitle,
                  fontSize: 13.sp,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
            _buildRadioButton(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(bool isSelected) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? context.colors.primary
              : context.colors.borderSecondary,
          width: 1.5.r,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12.r,
                height: 12.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.primary,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildAddOns() {
    return CustomContainer(
      horizontalMargin: 16.w,
      verticalMargin: 8.h,
      color: context.colors.background, // Just placing them without outer card
      child: Column(
        children: [
          _buildAddOnTile(
            index: 0,
            title: 'Extra dip sauce',
            subtitle: 'Garlic mayo or spicy ketchup',
            price: '+৳40',
          ),
          SizedBox(height: 8.h),
          _buildAddOnTile(
            index: 1,
            title: 'Cheese fries',
            subtitle: 'Regular fries topped with cheese',
            price: '+৳120',
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnTile({
    required int index,
    required String title,
    required String subtitle,
    required String price,
  }) {
    final isChecked = _selectedAddOns[index] ?? false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selectedAddOns[index] = !isChecked;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: subtitle,
                    fontSize: 13.sp,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
            CustomText(
              text: price,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: context.colors.textPrimary,
            ),
            SizedBox(width: 16.w),
            _buildCheckbox(isChecked),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isChecked) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        color: isChecked ? context.colors.primary : context.colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: isChecked
              ? context.colors.primary
              : context.colors.borderSecondary,
          width: 1.5,
        ),
      ),
      child: isChecked
          ? Icon(Icons.check, size: 16.r, color: context.colors.white)
          : null,
    );
  }
}
