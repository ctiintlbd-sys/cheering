import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/helpers/bottom_sheet_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/all_categories_bottom_sheet.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_categories_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/super_deals_card.dart';
import 'package:cheering/features/food/presentation/screens/widgets/bites_card.dart';
import 'package:cheering/features/food/presentation/screens/widgets/home_feed_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home_feed/home_feed_bloc.dart';
import '../blocs/home_feed/home_feed_event.dart';
import '../blocs/home_feed/home_feed_state.dart';
import '../../../../features/address/presentation/bloc/address_bloc.dart';
import '../../../../features/address/presentation/bloc/address_state.dart';

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
              ...switch (state.status) {
                HomeFeedStatus.initial ||
                HomeFeedStatus.loading => [const HomeFeedLoadingWidget()],
                HomeFeedStatus.failure => [
                  EmptyState(message: state.errorMessage ?? ''),
                ],
                HomeFeedStatus.success when state.feed != null => [
                  // Categories
                  if (state.feed!.categories.isNotEmpty) ...[
                    SizedBox(
                      height: 98.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.feed!.categories.length > 10
                            ? 11
                            : state.feed!.categories.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          if (state.feed!.categories.length > 10 &&
                              index == 10) {
                            return SeeAllCategoriesWidget(
                              onTap: () {
                                final bloc = context.read<HomeFeedBloc>();
                                BottomSheetHelper.showSheet(
                                  context: context,
                                  child: BlocProvider.value(
                                    value: bloc,
                                    child: const AllCategoriesBottomSheet(),
                                  ),
                                );
                              },
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: CustomItemAnimator(
                              index: index,
                              child: FoodCategoriesWidget(
                                category: state.feed!.categories[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Super Deals
                  if (state.feed!.promoted.isNotEmpty) ...[
                    SectionHeaderWidget(
                      title: 'Super Deals 🔥',
                      onTap: () {},
                    ).horizontal(16.w),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 228.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.feed!.promoted.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          return CustomItemAnimator(
                            index: index,
                            child: const SuperDealsCard(),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 28.h),
                  ],

                  // Bites (Static as requested)
                  SectionHeaderWidget(
                    title: 'Bites 🔥',
                    subtitle: 'Discover what everyone\'s eating',
                    onTap: () {},
                  ).horizontal(16.w),
                  SizedBox(height: 8.h),
                  const BitesItems(),
                  SizedBox(height: 20.h),

                  // Top Restaurants
                  if (state.feed!.topRated.isNotEmpty) ...[
                    SectionHeaderWidget(
                      title: 'Top Restaurants',
                      onTap: () {},
                    ).horizontal(16.w),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 202.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.feed!.topRated.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: CustomItemAnimator(
                              index: index,
                              child: const StoreCardWidget(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  SizedBox(height: 120.h),
                ],
                _ => [const SizedBox.shrink()],
              },
            ],
          );
        },
      ),
    );
  }
}
