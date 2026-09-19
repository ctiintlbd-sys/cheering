import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/helpers/bottom_sheet_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/all_categories_bottom_sheet.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_categories_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/super_deals_card.dart';
import 'package:cheering/features/food/presentation/screens/widgets/bites_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home_feed/home_feed_bloc.dart';
import '../blocs/home_feed/home_feed_event.dart';
import '../blocs/home_feed/home_feed_state.dart';
import '../../../../features/address/presentation/bloc/address_bloc.dart';
import '../../../../features/address/presentation/bloc/address_state.dart';
import 'package:shimmer/shimmer.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (previous, current) =>
          previous.activeDefaultId != current.activeDefaultId,
      listener: (context, state) {
        context.read<HomeFeedBloc>().add(const LoadHomeFeed());
      },
      child: BlocBuilder<HomeFeedBloc, HomeFeedState>(
        builder: (context, state) {
          return SliverScaffold(
            onRefresh: () async {
              context.read<HomeFeedBloc>().add(const LoadHomeFeed());
            },
            appBar: CustomSliverAppBar(
              toolbarHeight: 0,
              expandedHeight: 234.h,
              backgroundColor: context.colors.background,
              collapsedBgColor: context.colors.primary,
              flexibleChild: const DeliveryTitleWidget(),
              flexibleBackground: const FoodFlexibleBackground(imageUrl: ''),
              bottom: PreferredSize(
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

              if (state.status == HomeFeedStatus.loading ||
                  state.status == HomeFeedStatus.initial)
                _buildLoadingState(context)
              else if (state.status == HomeFeedStatus.failure)
                _buildErrorState(context, state.errorMessage)
              else if (state.status == HomeFeedStatus.success &&
                  state.feed != null) ...[
                // Categories
                SizedBox(
                  height: 98.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.feed!.categories.length > 10
                        ? 11
                        : state.feed!.categories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      if (state.feed!.categories.length > 10 && index == 10) {
                        return SeeAllCategoriesWidget(
                          onTap: () {
                            BottomSheetHelper.showSheet(
                              context: context,
                              child: const AllCategoriesBottomSheet(),
                            );
                          },
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: CustomItemAnimator(
                          index: index,
                          child: FoodCategoriesWidget(category: state.feed!.categories[index]), // Add category parameter to this widget later
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 24.h),
                SectionHeaderWidget(
                  title: 'Super Deals 🔥',
                  onTap: () {},
                ).horizontal(16.w),
                SizedBox(height: 10.h),

                // Super Deals
                SizedBox(
                  height: 228.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.feed!.promoted.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      return CustomItemAnimator(
                        index: index,
                        child:
                            const SuperDealsCard(), // Add store parameter to this widget later
                      );
                    },
                  ),
                ),

                SizedBox(height: 28.h),
                SectionHeaderWidget(
                  title: 'Bites 🔥',
                  subtitle: 'Discover what everyone\'s eating',
                  onTap: () {},
                ).horizontal(16.w),
                SizedBox(height: 8.h),

                // Bites (Static as requested)
                const BitesItems(),

                SizedBox(height: 20.h),
                SectionHeaderWidget(
                  title: 'Top Restaurants',
                  onTap: () {},
                ).horizontal(16.w),
                SizedBox(height: 10.h),

                // Top Restaurants
                SizedBox(
                  height: 202.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.feed!.topRated.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: CustomItemAnimator(
                          index: index,
                          child:
                              const StoreCardWidget(), // Add store parameter to this widget later
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 120.h),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.borderSecondary,
      highlightColor: context.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories shimmer
          SizedBox(
            height: 98.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(width: 50.w, height: 12.h, color: Colors.white),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
          // Deals title shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(width: 150.w, height: 20.h, color: Colors.white),
          ),
          SizedBox(height: 16.h),
          // Deals shimmer
          SizedBox(
            height: 228.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) => Container(
                width: 280.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Icon(Icons.error_outline, size: 48.w, color: context.colors.error),
            SizedBox(height: 16.h),
            Text(
              error ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () =>
                  context.read<HomeFeedBloc>().add(const LoadHomeFeed()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
