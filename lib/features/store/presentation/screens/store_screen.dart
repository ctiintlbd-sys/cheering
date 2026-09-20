import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/store/presentation/screens/widgets/store_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      onRefresh: () async {},
      appBar: CustomSliverAppBar(
        toolbarHeight: 0,
        expandedHeight: 234.w,
        backgroundColor: context.colors.background,
        collapsedBgColor: context.colors.primary,
        flexibleChild: const DeliveryTitleWidget(),
        flexibleBackground: FoodFlexibleBackground(
          imageUrl: '',
          fallbackAsset: Assets.images.store.image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(58.w),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.w),
            child: CustomTextField(
              onTap: () {},
              readOnly: true,
              prefixIcon: Assets.icons.search.svg(),
              suffixIcon: Assets.icons.filtter.svg(),
              borderRadius: 99.r,
              fillColor: context.colors.background,
              borderColor: context.colors.borderSecondary,
              hintText: 'Search for product or brands...',
            ),
          ),
        ),
      ),
      bodyList: [
        SizedBox(height: 20.w),

        SizedBox(
          height: 96.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                child: const StoreCategoriesWidget(),
              );
            },
          ),
        ),

        SizedBox(height: 24.w),
        SectionHeaderWidget(title: 'All Stores', onTap: () {}).horizontal(16.w),
        SizedBox(height: 10.w),
        SizedBox(
          height: 202.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4.w),
              //child: const StoreCardWidget(restaurant: null,),
            ),
          ),
        ),

        SizedBox(height: 20.w),
        SectionHeaderWidget(
          title: 'Top Pics for you',
          onTap: () {},
        ).horizontal(16.w),
        SizedBox(height: 10.w),
        SizedBox(
          height: 184.w,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4.w),
              child: const ProductCardWidget(),
            ),
          ),
        ),

        SizedBox(height: 120.w),
      ],
    );
  }
}
