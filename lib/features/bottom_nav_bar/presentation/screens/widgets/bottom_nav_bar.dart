import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/features/bottom_nav_bar/data/models/nav_item_model.dart';
import 'package:cheering/features/bottom_nav_bar/presentation/screens/widgets/nav_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  final List<NavItemModel> navItems;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 10.w),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final isSelected = selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onItemSelected(index);
                },
                child: BottomNavItem(
                  navItem: navItems[index],
                  isSelected: isSelected,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
