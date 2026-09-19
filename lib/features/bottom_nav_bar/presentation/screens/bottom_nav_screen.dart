import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/features/bottom_nav_bar/data/models/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/bottom_nav_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_event.dart';

class BottomNavScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavScreen({super.key, required this.navigationShell});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _onTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: context.colors.background,
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavBar(
        navItems: NavItemModel.navItems,
        selectedIndex: widget.navigationShell.currentIndex,
        onItemSelected: _onTabSelected,
      ),
    );
  }
}
