import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemContainer extends StatelessWidget {
  const CartItemContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      horizontalMargin: 16.w,
      paddingAll: 12.r,
      radiusAll: 12.r,
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.03),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
      color: context.colors.background,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'KFC - Badda',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              CustomText(text: '2 Items', color: context.colors.textSecondary),
            ],
          ),
          SizedBox(height: 16.w),

          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 2,
            separatorBuilder: (context, index) => SizedBox(height: 16.w),
            itemBuilder: (context, index) {
              return _buildCartItem(context: context);
            },
          ),
          SizedBox(height: 18.w),

          DottedBorderWidget(
            child: CustomButton(
              backgroundColor: Colors.transparent,
              fontSize: 14.w,
              fontWeight: FontWeight.w600,
              borderRadius: 12.r,
              prefixIcon: Icon(
                Icons.add,
                color: context.colors.primary,
                size: 14.r,
              ),
              foregroundColor: context.colors.primary,
              onPressed: () {},
              label: 'Add more items',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNetworkImage(
          borderRadius: 12.r,
          imageUrl: '',
          width: 66.w,
          height: 66.w,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Fried Chicken Bucket',
                fontWeight: FontWeight.w600,
                maxLines: 1,
              ),
              CustomText(
                top: 2.w,
                text: '8 pcs · Extra dip sauce',
                fontSize: 12.r,
                color: context.colors.textTertiary,
                maxLines: 1,
                bottom: 2.w,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: '৳650',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  QuantityButton(
                    count: 1,
                    onIncrement: () {},
                    onDecrement: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
