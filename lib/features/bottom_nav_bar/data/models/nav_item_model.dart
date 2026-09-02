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
}