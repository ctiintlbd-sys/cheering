import 'package:cheering/core/theme/app_theme_colors.dart';
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
    return Scaffold(
      extendBody: true,
      backgroundColor: context.colors.background,
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        navItems: NavItemModel.navItems,
        selectedIndex: navigationShell.currentIndex,
        onItemSelected: _onTabSelected,
      ),
    );
  }
}
