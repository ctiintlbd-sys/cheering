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
    this.collapsedBgColor,
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
  });

  final String? title;
  final double titleSize;
  final bool centerTitle;
  final Widget? titleWidget;

  final String? collapsedTitle;
  final Color? collapsedBgColor;

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

  double get _toolbarH => toolbarHeight ?? 60;

  double? get _expandedH =>
      (flexibleBackground != null || flexibleChild != null)
      ? (expandedHeight ?? _toolbarH)
      : null;

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
          top: _toolbarH + (flexiblePaddingTop ?? 0),
        ),
        child: flexibleChild,
      ),
    );

    return safeArea ? SafeArea(child: overlay) : overlay;
  }

  Widget? _buildFlexibleContent() {
    if (flexibleBackground == null && flexibleChild == null) {
      return null;
    }

    if (flexibleChild == null) {
      return flexibleBackground;
    }

    if (flexibleBackground == null) {
      return _buildChildOverlay();
    }

    return Stack(
      children: [
        Positioned.fill(child: flexibleBackground!),
        _buildChildOverlay(),
      ],
    );
  }

  Widget _buildTitleWidget(Color foreground) {
    return titleWidget ??
        Text(
          title ?? '',
          style: TextStyle(
            fontFamily: FontFamily.sFPro,
            fontWeight: FontWeight.w400,
            fontSize: titleSize.sp,
            color: foreground,
          ),
        );
  }

  Widget _buildCollapsedTitleWidget(Color foreground) {
    return titleWidget ??
        Text(
          collapsedTitle ?? title ?? '',
          style: TextStyle(
            fontFamily: FontFamily.sFPro,
            fontWeight: FontWeight.w400,
            fontSize: titleSize.sp,
            color: foreground,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = foregroundColor ?? colors.textPrimary;
    final baseColor = backgroundColor ?? colors.background;
    final targetColor = collapsedBgColor ?? baseColor;
    final fadedBg = colors.background.withValues(alpha: 0.1);
    final flexibleContent = _buildFlexibleContent();
    final builtLeading = _buildLeading(context);

    // Pre-build scroll-independent widgets
    final expandedTitle = _buildTitleWidget(foreground);
    final collapsedTitleWidget = _buildCollapsedTitleWidget(foreground);
    final titleSpacingWithLeading = 0.0;
    final titleSpacingWithout = 16.w;

    final resolvedShape = borderColor != null
        ? Border(
            bottom: BorderSide(color: borderColor!, width: borderWidth ?? 1),
          )
        : null;

    final resolvedFlexibleSpace = flexibleContent != null
        ? FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: flexibleContent,
          )
        : null;

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final collapseOffset = (_expandedH ?? _toolbarH) - _toolbarH;
        final isCollapsed = constraints.scrollOffset >= collapseOffset + 10.h;
        final t = collapseOffset > 0
            ? (constraints.scrollOffset / collapseOffset).clamp(0.0, 1.0)
            : (isCollapsed ? 1.0 : 0.0);
        final bg = Color.lerp(baseColor, targetColor, t)!;
        final resolvedLeading = isCollapsed ? null : builtLeading;

        final titleChild = isCollapsed ? collapsedTitleWidget : expandedTitle;
        final resolvedTitle = collapsedTitle != null
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey(isCollapsed),
                  child: titleChild,
                ),
              )
            : titleChild;

        return SliverAppBar(
          pinned: pinned || bottom != null,
          floating: floating,
          snap: snap,

          elevation: 0,
          scrolledUnderElevation: 0,

          shadowColor: fadedBg,
          surfaceTintColor: fadedBg,

          backgroundColor: bg,
          foregroundColor: foreground,

          toolbarHeight: _toolbarH,
          expandedHeight: _expandedH,

          automaticallyImplyLeading: false,

          titleSpacing: resolvedLeading == null
              ? titleSpacingWithout
              : titleSpacingWithLeading,

          centerTitle: centerTitle,
          leading: resolvedLeading,
          title: resolvedTitle,
          actions: isCollapsed ? null : actions,
          bottom: bottom,
          shape: resolvedShape,
          flexibleSpace: resolvedFlexibleSpace,
        );
      },
    );
  }
}
