import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/restaurant_details/restaurant_details_state.dart';
import 'package:cheering/features/store/presentation/screens/widgets/menu_item_widget.dart';
import 'package:cheering/features/store/presentation/screens/widgets/view_cart_button.dart';
import 'package:cheering/features/food/presentation/screens/widgets/restaurant_flexible_background.dart';
import 'package:cheering/features/food/presentation/screens/widgets/restaurant_app_bar_bottom.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late AutoScrollController _scrollController;
  final ValueNotifier<int> _activeIndexNotifier = ValueNotifier<int>(0);
  final List<GlobalKey> _sectionKeys = [];
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _activeIndexNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isAutoScrolling || _sectionKeys.isEmpty) return;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      if (key.currentContext != null) {
        final renderBox = key.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero).dy;
          // 416.w is the expanded height, 118.w is the bottom app bar, plus some safe margin
          if (position > 0 && position < 250) {
            if (_activeIndexNotifier.value != i) {
              _activeIndexNotifier.value = i;
            }
            break;
          }
        }
      }
    }
  }

  Future<void> _scrollToIndex(int index) async {
    _activeIndexNotifier.value = index;
    _isAutoScrolling = true;
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 400),
    );
    _isAutoScrolling = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsBloc, RestaurantDetailsState>(
      builder: (context, state) {
        final restaurant = state.restaurant;
        return SliverScaffold(
          scrollController: _scrollController,
          appBar: CustomSliverAppBar(
            toolbarHeight: 0,
            expandedHeight: 416.w,
            flexibleBackground: RestaurantFlexibleBackground(
              imageUrl: restaurant?.coverImageUrl ?? '',
            ),
            bottom: RestaurantAppBarBottom(
              categories: state.menuCategories,
              activeIndexNotifier: _activeIndexNotifier,
              onTabTapped: _scrollToIndex,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: ViewCartButton(
            itemCount: 1,
            totalPrice: 650,
            onTap: () {},
          ),
          bodyList: _buildBody(state),
        );
      },
    );
  }


  List<Widget> _buildBody(RestaurantDetailsState state) {
    return switch (state.status) {
      RestaurantDetailsStatus.initial || RestaurantDetailsStatus.loading => [
        SizedBox(height: 100.w),
        const Center(child: CircularProgressIndicator()),
        SizedBox(height: 300.w),
      ],
      RestaurantDetailsStatus.failure => [
        SizedBox(height: 100.w),
        Center(
          child: Text(
            state.errorMessage ?? 'Error',
            style: TextStyle(color: context.colors.error),
          ),
        ),
        SizedBox(height: 300.w),
      ],
      RestaurantDetailsStatus.success => _buildMenuSections(
        state.menuCategories,
      ),
    };
  }

  List<Widget> _buildMenuSections(List<MenuCategoryEntity> categories) {
    if (categories.isEmpty) {
      return [
        SizedBox(height: 100.w),
        const Center(child: Text("No menu available")),
        SizedBox(height: 300.w),
      ];
    }

    final List<Widget> slivers = [];
    slivers.add(SizedBox(height: 20.w));

    if (_sectionKeys.length != categories.length) {
      _sectionKeys.clear();
      _sectionKeys.addAll(List.generate(categories.length, (_) => GlobalKey()));
    }

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      slivers.add(
        AutoScrollTag(
          key: ValueKey(i),
          controller: _scrollController,
          index: i,
          child: Column(
            key: _sectionKeys[i],
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: category.name,
                fontSize: 20.r,
                fontWeight: FontWeight.w700,
              ).horizontal(16.w),
              SizedBox(height: 12.w),

              // We simulate the items since MenuCategoryEntity might just have names for now
              // If it has List<MenuItemEntity> items, we loop over them.
              // Assuming we use MenuItemWidget for now
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: 5, // Replace with category.items.length later
                separatorBuilder: (context, index) => SizedBox(height: 16.w),
                itemBuilder: (context, itemIndex) {
                  return CustomItemAnimator(
                    index: itemIndex,
                    animationType: CustomItemAnimationType.slide,
                    child: MenuItemWidget(index: itemIndex),
                  );
                },
              ),
              SizedBox(height: 24.w),
            ],
          ),
        ),
      );
    }

    slivers.add(SizedBox(height: 140.w));
    return slivers;
  }
}
