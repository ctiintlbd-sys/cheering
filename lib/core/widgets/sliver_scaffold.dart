import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cheering/core/theme/app_theme_colors.dart';
import 'custom_sliver_app_bar.dart';

class SliverScaffold extends StatefulWidget {
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
    this.sideContentPadding,
    this.extendBody = true,
    this.isNavWrap = true,
    this.extendBodyBehindAppBar = false,
  }) : onLoadMore = null,
       threshold = 200;

  const SliverScaffold.paginated({
    super.key,
    this.appBar,
    required this.bodyList,
    required this.onLoadMore,
    this.threshold = 200,
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
    this.sideContentPadding,
    this.extendBody = true,
    this.isNavWrap = true,
    this.extendBodyBehindAppBar = false,
  });

  final Widget? appBar;
  final List<Widget> bodyList;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final Widget? bottomNavigationBar;

  final Widget? drawer;
  final Widget? endDrawer;

  final Color? backgroundColor;

  final bool? resizeToAvoidBottomInset;

  final bool extendBody;
  final bool isNavWrap;
  final bool extendBodyBehindAppBar;

  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;

  final Future<void> Function()? onRefresh;

  final double? sideContentPadding;

  /// Pagination
  final VoidCallback? onLoadMore;
  final double threshold;

  @override
  State<SliverScaffold> createState() => _SliverScaffoldState();
}

class _SliverScaffoldState extends State<SliverScaffold> {
  ScrollController? _internalController;

  ScrollController get _effectiveController =>
      widget.scrollController ?? (_internalController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    if (widget.onLoadMore != null) {
      _effectiveController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    final position = _effectiveController.position;
    if (position.pixels >= position.maxScrollExtent - widget.threshold) {
      widget.onLoadMore!();
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  static const _defaultPhysics = AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics(),
  );

  static bool _isSliver(Widget w) =>
      w is SliverToBoxAdapter ||
      w is SliverList ||
      w is SliverGrid ||
      w is SliverPadding ||
      w is SliverFillRemaining ||
      w is SliverFillViewport ||
      w is SliverAppBar ||
      w is CustomSliverAppBar ||
      w is SliverFixedExtentList ||
      w is SliverAnimatedList ||
      w is SliverAnimatedGrid ||
      w is SliverPersistentHeader;

  List<Widget> _buildSlivers() {
    final padding = widget.sideContentPadding != null
        ? EdgeInsets.symmetric(horizontal: widget.sideContentPadding!.w)
        : null;

    return [
      if (widget.appBar != null) widget.appBar!,

      if (widget.onRefresh != null)
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh!,
          builder:
              (
                context,
                mode,
                pulledExtent,
                refreshTriggerPullDistance,
                refreshIndicatorExtent,
              ) => _RefreshIndicator(
                mode: mode,
                pulledExtent: pulledExtent,
                refreshTriggerPullDistance: refreshTriggerPullDistance,
                refreshIndicatorExtent: refreshIndicatorExtent,
              ),
        ),

      for (final w in widget.bodyList)
        if (_isSliver(w))
          w
        else
          SliverToBoxAdapter(
            child: padding != null ? Padding(padding: padding, child: w) : w,
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? context.colors.background;

    return Scaffold(
      backgroundColor: bg,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset ?? true,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.floatingActionButton != null
          ? RepaintBoundary(child: widget.floatingActionButton!)
          : null,
      bottomNavigationBar: widget.bottomNavigationBar != null && widget.isNavWrap
          ? RepaintBoundary(
              child: _BottomNavWrapper(backgroundColor: widget.backgroundColor, child: widget.bottomNavigationBar!),
            )
          : widget.bottomNavigationBar,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          controller: _effectiveController,
          physics: widget.scrollPhysics ?? _defaultPhysics,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          slivers: _buildSlivers(),
        ),
      ),
    );
  }
}

class _RefreshIndicator extends StatelessWidget {
  const _RefreshIndicator({
    required this.mode,
    required this.pulledExtent,
    required this.refreshTriggerPullDistance,
    required this.refreshIndicatorExtent,
  });

  final RefreshIndicatorMode mode;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;

  @override
  Widget build(BuildContext context) {
    final progress = refreshTriggerPullDistance > 0
        ? (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0)
        : 0.0;

    final isRefreshing = mode == RefreshIndicatorMode.refresh;

    return SizedBox(
      height: isRefreshing ? refreshIndicatorExtent : pulledExtent,
      child: Center(
        child: Opacity(
          opacity: isRefreshing ? 1.0 : progress,
          child: SizedBox(
            height: 22.w,
            width: 22.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              value: isRefreshing ? null : progress,
              color: context.colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavWrapper extends StatelessWidget {
  const _BottomNavWrapper({required this.child,  this.backgroundColor});

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor?.withValues(alpha: 0.6) ?? context.colors.background.withValues(alpha: 0.6),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16.w,
          10.w,
          16.w,
          MediaQuery.paddingOf(context).bottom + 8.w,
        ),
        child: child,
      ),
    );
  }
}

extension WidgetPaddingExtension on Widget {
  Widget horizontal([double padding = 16]) => Padding(
    padding: EdgeInsets.symmetric(horizontal: padding.w),
    child: this,
  );
}
