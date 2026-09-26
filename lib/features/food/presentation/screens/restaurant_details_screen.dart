import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/delivery_time_sheet.dart';
import 'package:cheering/features/orders/domain/entities/order_schedule_state.dart';
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
import 'package:cheering/features/store/presentation/screens/widgets/menu_item_shimmer.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> _handleClosedRestaurant(RestaurantEntity restaurant) async {
    if (restaurant.businessHours == null || restaurant.businessHours!.isEmpty) {
      ToastMessageHelper.show('Business hours are not available for this restaurant.');
      context.pop();
      return;
    }
    final selectedTime = await DeliveryTimeSheet.show(context, restaurant.businessHours!);
    if (selectedTime != null) {
      OrderScheduleState.setSchedule(restaurant.id, selectedTime);
    }else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantDetailsBloc, RestaurantDetailsState>(
      listenWhen: (previous, current) => 
          previous.status != current.status && 
          current.status == RestaurantDetailsStatus.success,
      listener: (context, state) {
        final restaurant = state.restaurant;
        if (restaurant != null && !restaurant.isOpen) {
          _handleClosedRestaurant(restaurant);
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final restaurant = state.restaurant;
        return SliverScaffold(
          scrollController: _scrollController,
          appBar: CustomSliverAppBar(
                toolbarHeight: 0,
                expandedHeight: 416.w,
                flexibleBackground: RestaurantFlexibleBackground(
                  restaurant: restaurant,
                ),
                bottom: RestaurantAppBarBottom(
                  categories: state.validMenuCategories,
                  activeIndexNotifier: _activeIndexNotifier,
                  onTabTapped: _scrollToIndex,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  final itemCount = cartState.cart?.itemCount ?? 0;
                  if (itemCount == 0) return const SizedBox.shrink();
                  return ViewCartButton(
                    itemCount: itemCount,
                    totalPrice: cartState.cart?.itemTotal ?? 0,
                    onTap: () {
                      context.push(RoutePaths.cart);
                    },
                  );
                },
              ),
              bodyList: switch (state.status) {
                RestaurantDetailsStatus.initial ||
                RestaurantDetailsStatus.loading => [
                  const MenuItemShimmer(count: 6),
                ],
                RestaurantDetailsStatus.failure => [
                  EmptyState(message: state.errorMessage ?? ''),
                ],
                RestaurantDetailsStatus.success => _buildMenuSections(
                  state.validMenuCategories,
                ),
              },
            );
          },
        );
  }

  List<Widget> _buildMenuSections(List<MenuCategoryEntity> categories) {
    if (categories.isEmpty) {
      return [
        SizedBox(height: 100.w),
        const Center(child: Text("No menu available")),
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
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: category.items.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.w),
                itemBuilder: (context, itemIndex) {
                  return CustomItemAnimator(
                    index: itemIndex,
                    animationType: CustomItemAnimationType.slide,
                    child: MenuItemWidget(
                      menuItem: category.items[itemIndex],
                    ),
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
