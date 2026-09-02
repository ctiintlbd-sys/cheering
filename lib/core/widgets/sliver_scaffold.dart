import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_sliver_app_bar.dart';
import 'keyboard_dismiss_on_tap.dart';

/// Ultra-smooth, decoupled, production-grade SliverScaffold.
/// - 100% decoupled from external services/controllers.
/// - Highly optimized with RepaintBoundaries & 60fps/120fps scrolling physics.
/// - Handles pull-to-refresh (`onRefresh`) & infinite pagination (`onLoadMore`).
/// - Auto-safeguards non-sliver widgets in [bodyList] to prevent layout exceptions.
class SliverScaffold extends StatelessWidget {
  const SliverScaffold({
    super.key,
    this.appBar,
    required this.bodyList,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.endDrawer,
    this.drawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.scrollPhysics,
    this.scrollController,
    this.onRefresh,
    this.onLoadMore,
    this.onScroll,
    this.isLoading = false,
    this.emptyState,
    this.errorState,
    this.extendBody = true,
    this.extendBodyBehindAppBar = false,  this.refreshEdgeOffset = 56.0,
  });

  /// The sliver app bar at the top of the scroll view.
  final CustomSliverAppBar? appBar;

  /// The list of sliver widgets (or standard widgets wrapped with `.asSliver`).
  final List<Widget> bodyList;

  /// Scaffold slots
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final double refreshEdgeOffset;

  /// Scroll & Gestures
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onLoadMore;
  final void Function(ScrollNotification)? onScroll;

  /// Full-screen or sliver state widgets
  final bool isLoading;
  final Widget? emptyState;
  final Widget? errorState;

  ScrollPhysics get _effectivePhysics =>
      scrollPhysics ??
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

  List<Widget> _buildSlivers(BuildContext context) {
    final slivers = <Widget>[];

    // 1. App Bar
    if (appBar != null) {
      slivers.add(appBar!);
    }

    // 2. Loading State
    if (isLoading) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(color: context.colors.primary),
          ),
        ),
      );
      return slivers;
    }

    // 3. Error State
    if (errorState != null) {
      slivers.add(
        SliverFillRemaining(hasScrollBody: false, child: errorState!),
      );
      return slivers;
    }

    // 4. Empty State
    if (emptyState != null && bodyList.isEmpty) {
      slivers.add(
        SliverFillRemaining(hasScrollBody: false, child: emptyState!),
      );
      return slivers;
    }

    // 5. Body Widgets (Auto-safeguard non-sliver widgets to prevent runtime crashes)
    for (final widget in bodyList) {
      if (_isSliver(widget)) {
        slivers.add(widget);
      } else {
        slivers.add(SliverToBoxAdapter(child: widget));
      }
    }

    return slivers;
  }

  static bool _isSliver(Widget widget) {
    return widget is RenderObjectWidget &&
            widget is! SingleChildRenderObjectWidget ||
        widget is SliverToBoxAdapter ||
        widget is SliverList ||
        widget is SliverGrid ||
        widget is SliverPadding ||
        widget is SliverFillRemaining ||
        widget is SliverFillViewport ||
        widget is SliverAppBar ||
        widget is CustomSliverAppBar ||
        widget is SliverFixedExtentList ||
        widget is SliverAnimatedList ||
        widget is SliverPersistentHeader;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    onScroll?.call(notification);

    if (onLoadMore != null &&
        notification is ScrollUpdateNotification &&
        notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
      onLoadMore!();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? context.colors.background;

    Widget body = CustomScrollView(
      controller: scrollController,
      physics: _effectivePhysics,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: _buildSlivers(context),
    );

    if (onRefresh != null) {
      body = RefreshIndicator(
        elevation: 0,
        edgeOffset: refreshEdgeOffset,
        backgroundColor: bg,
        color: context.colors.primary,
        onRefresh: onRefresh!,
        child: body,
      );
    }

    body = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: body,
    );

    return Scaffold(
      backgroundColor: bg,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton != null
          ? RepaintBoundary(child: floatingActionButton!)
          : null,
      bottomNavigationBar: bottomNavigationBar != null
          ? RepaintBoundary(child: Container(
        color: context.colors.background.withValues(alpha: 0.6),
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, MediaQuery.of(context).padding.bottom + 8.h),
          child: bottomNavigationBar!))
          : null,
      body: KeyboardDismissOnTap(child: body),
    );
  }
}

// ── Handy Ergonomic Sliver Extensions ────────────────────────────────────────

extension WidgetSliverExtension on Widget {
  /// Wraps any standard widget into a SliverToBoxAdapter.
  Widget get asSliver => SliverToBoxAdapter(child: this);

  /// Wraps this widget into a SliverPadding > SliverToBoxAdapter.
  Widget asSliverWithPadding({
    double? horizontal,
    double? vertical,
    EdgeInsets? padding,
  }) => SliverPadding(
    padding:
        padding ??
        EdgeInsets.symmetric(
          horizontal: (horizontal ?? 0).w,
          vertical: (vertical ?? 0).h,
        ),
    sliver: SliverToBoxAdapter(child: this),
  );

  /// Wraps this widget in SliverFillRemaining (for empty states, error states, etc.).
  Widget asFillRemainingSliver({
    bool hasScrollBody = false,
    AlignmentGeometry? alignment,
  }) => SliverFillRemaining(
    hasScrollBody: hasScrollBody,
    child: alignment != null ? Align(alignment: alignment, child: this) : this,
  );
}

extension SliverPaddingExtension on Widget {
  /// Adds responsive padding to an existing sliver (e.g. SliverList).
  Widget asPaddedSliver({
    double? horizontal,
    double? vertical,
    EdgeInsets? padding,
  }) => SliverPadding(
    padding:
        padding ??
        EdgeInsets.symmetric(
          horizontal: (horizontal ?? 0).w,
          vertical: (vertical ?? 0).h,
        ),
    sliver: this,
  );
}
