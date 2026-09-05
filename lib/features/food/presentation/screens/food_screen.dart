import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/delivery_title_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_flexible_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(
        toolbarHeight: 0,
        expandedHeight: 234.h,
       backgroundColor: context.colors.background,
       collapsedBgColor: context.colors.primary,
        flexibleChild: const DeliveryTitleWidget(address: 'House 25, Banani Rd 11...',),
        flexibleBackground: const FoodFlexibleBackground(),
        bottom:  PreferredSize(
          preferredSize: Size.fromHeight(58.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
            child: CustomTextField(
              onTap: () {},
              readOnly: true,
              prefixIcon: Assets.icons.search.svg(),
              suffixIcon: Assets.icons.filtter.svg(),
              borderRadius: 99.r,
              fillColor: context.colors.background,
              borderColor: context.colors.borderSecondary,
              hintText: 'Search for restaurant...',
            ),
          ),
        ),
      ),
      bodyList: [
        SizedBox(height: 20.h),

        SizedBox(
          height: 98.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return CustomContainer(
                verticalMargin: 4.h,
                width: 74.w,
                height: 90.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomContainer(
                      width: 68.r,
                      height: 68.r,
                      radiusAll: 48.r,
                      alignment: Alignment.center,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 0),
                          blurRadius: 6,
                          color: context.colors.black.withValues(alpha: 0.09),
                        ),
                      ],
                      child: CustomNetworkImage(
                        width: 50.r,
                        height: 50.r,
                        boxShape: BoxShape.circle,
                        imageUrl: '',
                        fallbackAsset: Assets.icons.menu.svg(),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    SizedBox(
                      width: 74.w,
                      height: 16.h,
                      child: CustomText(
                        text: 'Chicken',
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
