import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/features/bottom_nav_bar/data/models/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/bottom_nav_bar.dart';

class BottomNavScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavScreen({super.key, required this.navigationShell});

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItems = [
      NavItemModel(
        label: 'Food',
        icon: Assets.icons.food.path,
        activeIcon: Assets.icons.foodFil.path,
      ),
      NavItemModel(
        label: 'Store',
        icon: Assets.icons.store.path,
        activeIcon: Assets.icons.storeFil.path,
      ),
      NavItemModel(
        label: 'Order',
        icon: Assets.icons.order.path,
        activeIcon: Assets.icons.orderFil.path,
      ),
      NavItemModel(
        label: 'Community',
        icon: Assets.icons.community.path,
        activeIcon: Assets.icons.communityFil.path,
      ),
      NavItemModel(
        label: 'Profile',
        icon: Assets.icons.profile.path,
        activeIcon: Assets.icons.profileFil.path,
      ),
    ];
    return Scaffold(
      extendBody: true,
      backgroundColor: context.colors.background,
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        navItems: navItems,
        selectedIndex: navigationShell.currentIndex,
        onItemSelected: _onTabSelected,
      ),
    );
  }
}
