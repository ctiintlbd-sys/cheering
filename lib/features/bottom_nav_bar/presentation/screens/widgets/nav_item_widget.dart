import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/features/bottom_nav_bar/data/models/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavItem extends StatefulWidget {
  final NavItemModel navItem;
  final bool isSelected;

  const BottomNavItem({
    super.key,
    required this.navItem,
    required this.isSelected,
  });

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.85,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.85,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
    ]).animate(_animController);
  }

  @override
  void didUpdateWidget(covariant BottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemColor = widget.isSelected
        ? context.colors.primary
        : context.colors.iconSecondary;

    final iconPath = (widget.isSelected && widget.navItem.activeIcon != null)
        ? widget.navItem.activeIcon!
        : widget.navItem.icon;

    return ScaleTransition(
      scale: _scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Icon & Optional Badges ─────────────────────────────────
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: itemColor),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                builder: (context, color, _) {
                  return SvgPicture.asset(iconPath, width: 24.w, height: 24.h);
                },
              ),

              // Live Number Badge (e.g. Order Count)
              if (widget.navItem.badgeCount > 0)
                Positioned(
                  top: -4.h,
                  right: -8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: context.colors.background,
                        width: 1.5.w,
                      ),
                    ),
                    constraints: BoxConstraints(minWidth: 16.w),
                    child: Text(
                      widget.navItem.badgeCount > 99
                          ? '99+'
                          : '${widget.navItem.badgeCount}',
                      style: TextStyle(
                        fontFamily: FontFamily.sFPro,
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              // Dot Badge Indicator
              if (widget.navItem.showBadgeDot && widget.navItem.badgeCount == 0)
                Positioned(
                  top: -1.h,
                  right: -2.w,
                  child: Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.background,
                        width: 1.2.w,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),

          // ── Label ──────────────────────────────────────────────────
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            style: TextStyle(
              fontFamily: FontFamily.sFPro,
              fontSize: 11.sp,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
              color: itemColor,
            ),
            child: Text(widget.navItem.label),
          ),
        ],
      ),
    );
  }
}
