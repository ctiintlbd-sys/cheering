import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleSize = 18,
    this.centerTitle = false,
    this.titleWidget,
    this.collapsedTitle,
    this.collapsedTitleColor,
    this.showLeading = true,
    this.actions,
    this.backAction,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.toolbarHeight,
    this.expandedHeight,
    this.flexibleBackground,
    this.flexibleChild,
    this.flexiblePaddingTop,
    this.flexibleAlignment = Alignment.topCenter,
    this.safeArea = true,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.bottom,
    this.innerBoxIsScrolled = false,
    this.collapseToolbar = false,
  });

  // ── Fields ───────────────────────────────────────────────────

  final String? title;
  final double titleSize;
  final bool centerTitle;
  final Widget? titleWidget;

  final String? collapsedTitle;
  final Color? collapsedTitleColor;

  final bool showLeading;
  final List<Widget>? actions;
  final VoidCallback? backAction;
  final Widget? leading;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final Color? borderColor;
  final double? borderWidth;

  final double? toolbarHeight;
  final double? expandedHeight;

  final Widget? flexibleBackground;
  final Widget? flexibleChild;
  final double? flexiblePaddingTop;
  final AlignmentGeometry flexibleAlignment;

  final bool safeArea;
  final bool pinned;
  final bool floating;
  final bool snap;

  final PreferredSizeWidget? bottom;
  final bool innerBoxIsScrolled;
  final bool collapseToolbar;

  bool get _isCollapseMode => collapseToolbar && bottom != null;

  double get _toolbarH => toolbarHeight ?? 60;

  double? get _expandedH =>
      (flexibleBackground != null || flexibleChild != null)
      ? (expandedHeight ?? _toolbarH)
      : null;

  // ── Builders ─────────────────────────────────────────────────

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    if (!showLeading || !canPop) return null;
    return IconButton(
      padding: EdgeInsets.only(left: 8.w),
      onPressed: backAction ?? () => Navigator.maybePop(context),
      icon: Assets.icons.arrowBack.svg(height: 24.h, width: 24.w),
    );
  }

  Widget _buildChildOverlay() {
    final overlay = Align(
      alignment: flexibleAlignment,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: _isCollapseMode
              ? (flexiblePaddingTop ?? 0)
              : _toolbarH + (flexiblePaddingTop ?? 0),
        ),
        child: flexibleChild,
      ),
    );
    return safeArea ? SafeArea(child: overlay) : overlay;
  }

  Widget? _buildFlexibleContent() {
    if (flexibleBackground == null && flexibleChild == null) return null;

    if (flexibleChild == null) return flexibleBackground;

    if (flexibleBackground == null) return _buildChildOverlay();
    return Stack(
      children: [
        Positioned.fill(child: flexibleBackground!),
        _buildChildOverlay(),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, Color foreground) {
    final showCollapsed = innerBoxIsScrolled && collapsedTitle != null;
    final fg = showCollapsed ? (collapsedTitleColor ?? foreground) : foreground;

    final child =
        titleWidget ??
        Text(
          showCollapsed ? (collapsedTitle ?? title ?? '') : (title ?? ''),
          style: TextStyle(
            fontFamily: FontFamily.sFPro,
            fontWeight: FontWeight.w400,
            fontSize: titleSize.sp,
            color: fg,
          ),
        );

    if (collapsedTitle == null) return child;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: KeyedSubtree(key: ValueKey(showCollapsed), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = foregroundColor ?? context.colors.textPrimary;
    final bg = backgroundColor ?? context.colors.background;
    final resolvedLeading = _isCollapseMode ? null : _buildLeading(context);
    final flexibleContent = _buildFlexibleContent();

    return SliverAppBar(
      pinned: pinned || bottom != null,
      floating: floating,
      snap: snap,

      elevation: 0,
      scrolledUnderElevation: _isCollapseMode ? 0 : 10,
      shadowColor: context.colors.background.withValues(alpha: 0.1),
      surfaceTintColor: context.colors.background.withValues(alpha: 0.1),

      backgroundColor: bg,
      foregroundColor: foreground,

      toolbarHeight: _isCollapseMode ? 0 : _toolbarH,
      expandedHeight: _isCollapseMode
          ? (expandedHeight ?? _toolbarH)
          : _expandedH,

      automaticallyImplyLeading: false,
      titleSpacing: resolvedLeading == null ? 16.w : 0,
      centerTitle: centerTitle,

      leading: resolvedLeading,
      title: _isCollapseMode ? null : _buildTitle(context, foreground),
      actions: _isCollapseMode ? null : actions,

      bottom: bottom,

      shape: borderColor != null
          ? Border(
              bottom: BorderSide(color: borderColor!, width: borderWidth ?? 1),
            )
          : null,

      flexibleSpace: flexibleContent != null
          ? FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: flexibleContent,
            )
          : null,
    );
  }
}
