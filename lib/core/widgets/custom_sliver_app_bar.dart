import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ultra-smooth, decoupled, high-performance CustomSliverAppBar.
/// - Fully theme-reactive (Light & Dark mode).
/// - Completely decoupled from any rigid third-party dependencies.
/// - Supports custom flexible headers, tabs (bottom), actions, and leading icons.
class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleSize = 18,
    this.centerTitle = true,
    this.showLeading = true,
    this.leading,
    this.backAction,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.toolbarHeight,
    this.expandedHeight,
    this.flexibleSpace,
    this.flexibleChild,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.elevation = 0,
    this.scrolledUnderElevation = 2,
  });

  final String? title;
  final Widget? titleWidget;
  final double titleSize;
  final bool centerTitle;
  final bool showLeading;
  final Widget? leading;
  final VoidCallback? backAction;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? toolbarHeight;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final Widget? flexibleChild;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double elevation;
  final double scrolledUnderElevation;

  double get _toolbarH => toolbarHeight ?? 54.h;

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    if (!showLeading) return null;

    final canPop = Navigator.canPop(context);
    if (!canPop && backAction == null) return null;

    return IconButton(
      icon: Assets.icons.arrowBack.svg(),
      onPressed: backAction ?? () => Navigator.maybePop(context),
      splashRadius: 24.r,
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (titleWidget != null) return titleWidget;
    if (title == null || title!.isEmpty) return null;

    return Text(
      title!,
      style: TextStyle(
        fontFamily: FontFamily.sFPro,
        fontWeight: FontWeight.w600,
        fontSize: titleSize.sp,
        color: foregroundColor ?? context.colors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? context.colors.background.withValues(alpha: 0.95);

    return SliverAppBar(
      pinned: pinned || bottom != null,
      floating: floating,
      snap: snap,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: context.colors.background.withValues(alpha: 0.08),
      surfaceTintColor: effectiveBg,
      backgroundColor: effectiveBg,
      foregroundColor: foregroundColor ?? context.colors.textPrimary,
      toolbarHeight: _toolbarH,
      expandedHeight: expandedHeight,
      automaticallyImplyLeading: false,
      titleSpacing: showLeading ? 0 : 16.w,
      centerTitle: centerTitle,
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: actions != null
          ? [
              ...actions!,
              SizedBox(width: 8.w),
            ]
          : null,
      bottom: bottom,
      shape: borderColor != null
          ? Border(
              bottom: BorderSide(
                color: borderColor!,
                width: borderWidth ?? 1,
              ),
            )
          : null,
      flexibleSpace: flexibleSpace ??
          (flexibleChild != null
              ? FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: _toolbarH,
                        bottom: bottom?.preferredSize.height ?? 0,
                      ),
                      child: Center(
                        child: flexibleChild!,
                      ),
                    ),
                  ),
                )
              : null),
    );
  }
}