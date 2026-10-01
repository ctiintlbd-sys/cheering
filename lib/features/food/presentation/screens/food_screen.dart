import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/features/food/presentation/screens/widgets/bites_section.dart';
import 'package:cheering/features/food/presentation/screens/widgets/home_feed_loading_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/home_feed_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home_feed/home_feed_bloc.dart';
import '../blocs/home_feed/home_feed_event.dart';
import '../blocs/home_feed/home_feed_state.dart';
import '../blocs/reels/reels_bloc.dart';
import '../blocs/reels/reels_event.dart';
import '../../../../features/address/presentation/bloc/address_bloc.dart';
import '../../../../features/address/presentation/bloc/address_state.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (previous, current) =>
          previous.activeAddress != current.activeAddress,
      listener: (context, state) {
        context.read<HomeFeedBloc>().add(const LoadHomeFeed());
      },
      child: BlocBuilder<HomeFeedBloc, HomeFeedState>(
        builder: (context, state) {
          return SliverScaffold(
            onRefresh: () async {
              context.read<HomeFeedBloc>().add(const LoadHomeFeed());
              context.read<ReelsBloc>().add(const RefreshReels());
            },
            appBar: CustomSliverAppBar(
              toolbarHeight: 0,
              expandedHeight: 234.w,
              backgroundColor: context.colors.background,
              collapsedBgColor: context.colors.primary,
              flexibleChild: const DeliveryTitleWidget(),
              flexibleBackground: const FoodFlexibleBackground(imageUrl: ''),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(58.w),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.w),
                  child: CustomTextField(
                    onTap: () => context.push(RoutePaths.search),
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
            bodyList: switch (state.status) {
              HomeFeedStatus.initial ||
              HomeFeedStatus.loading => [const HomeFeedLoadingWidget()],
              HomeFeedStatus.failure => [
                EmptyState(message: state.errorMessage ?? ''),
              ],
              HomeFeedStatus.success when state.feed == null => [
                EmptyState(message: state.errorMessage ?? ''),
              ],
              HomeFeedStatus.success => [
                SizedBox(height: 20.w),
                if (state.feed!.categories.isNotEmpty)
                  CategoriesSection(categories: state.feed!.categories),

                if (state.feed!.nearby.isNotEmpty)
                  NearbyRestaurantsSection(nearby: state.feed!.nearby),

                // if (state.feed!.promoted.isNotEmpty)
                // SuperDealsSection(promoted: state.feed!.promoted),
                const BitesSection(),

                if (state.feed!.topRated.isNotEmpty)
                  TopRestaurantsSection(topRated: state.feed!.topRated),

                SizedBox(height: 120.w),
              ],
            },
          );
        },
      ),
    );
  }
}
