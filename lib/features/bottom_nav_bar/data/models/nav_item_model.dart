import 'package:cheering/core/utils/assets/assets.gen.dart';

class NavItemModel {
  final String icon;
  final String? activeIcon;
  final String label;
  final int badgeCount;
  final bool showBadgeDot;

  const NavItemModel({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount = 0,
    this.showBadgeDot = false,
  });

  static final navItems = [
    NavItemModel(
      label: 'Food',
      icon: Assets.icons.food.path,
      activeIcon: Assets.icons.foodFil.path,
    ),
   /* NavItemModel(
      label: 'Store',
      icon: Assets.icons.store.path,
      activeIcon: Assets.icons.storeFil.path,
    ),*/
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
}
