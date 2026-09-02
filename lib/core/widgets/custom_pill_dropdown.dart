import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

/// Selection state model for isolated, high-performance rebuilding.
class _DropdownState<T> {
  final bool isAllSelected;
  final Set<String> selectedIds;
  final List<T> selectedItems;
  final String label;

  const _DropdownState({
    required this.isAllSelected,
    required this.selectedIds,
    required this.selectedItems,
    required this.label,
  });
}

/// Ultra-smooth, highly optimized generic pill-style dropdown widget.
/// Uses [ValueNotifier] & [ListView.builder] with O(1) Set lookups
/// to eliminate redundant parent/list rebuilds.
class CustomPillDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) itemTitle;
  final String? Function(T item)? itemSubtitle;
  final String? Function(T item)? itemImageUrl;
  final Widget? Function(T item)? itemIcon;
  final String Function(T item)? itemId;

  // ── "Select All" Configuration ──
  final bool showSelectAll;
  final String selectAllTitle;
  final String? selectAllSubtitle;
  final Widget? selectAllIcon;

  // ── State & Selection ──
  final List<T> initialSelectedItems;
  final bool isMultiSelect;
  final String emptyLabel;
  final String Function(int count)? countLabel;

  // ── Callbacks ──
  final void Function(List<T> selectedItems)? onChanged;

  // ── Customization ──
  final double? width;
  final double maxHeight;

  const CustomPillDropdown({
    super.key,
    required this.items,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemImageUrl,
    this.itemIcon,
    this.itemId,
    this.showSelectAll = true,
    this.selectAllTitle = 'All items',
    this.selectAllSubtitle,
    this.selectAllIcon,
    this.initialSelectedItems = const [],
    this.isMultiSelect = true,
    this.emptyLabel = 'Select items',
    this.countLabel,
    this.onChanged,
    this.width,
    this.maxHeight = 300,
  });

  @override
  State<CustomPillDropdown<T>> createState() => _CustomPillDropdownState<T>();
}

class _CustomPillDropdownState<T> extends State<CustomPillDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<_DropdownState<T>> _stateNotifier;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  late final AnimationController _arrowAnimController;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _stateNotifier = ValueNotifier<_DropdownState<T>>(_computeInitialState());

    _arrowAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _arrowAnimController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(CustomPillDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      final current = _stateNotifier.value;
      if (current.isAllSelected) {
        final allIds = widget.items.map(_getId).toSet();
        _stateNotifier.value = _DropdownState<T>(
          isAllSelected: true,
          selectedIds: allIds,
          selectedItems: List.from(widget.items),
          label: '${widget.selectAllTitle} ',
        );
      } else {
        // Filter out items that might no longer exist
        final validItems = widget.items
            .where((i) => current.selectedIds.contains(_getId(i)))
            .toList();
        final validIds = validItems.map(_getId).toSet();
        _stateNotifier.value = _DropdownState<T>(
          isAllSelected: false,
          selectedIds: validIds,
          selectedItems: validItems,
          label: _deriveLabel(false, validItems),
        );
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _stateNotifier.dispose();
    _arrowAnimController.dispose();
    super.dispose();
  }

  String _getId(T item) {
    if (widget.itemId != null) {
      return widget.itemId!(item);
    }
    return item.hashCode.toString();
  }

  String _deriveLabel(bool isAll, List<T> items) {
    if (isAll) {
      return '${widget.selectAllTitle} ';
    } else if (items.isEmpty) {
      return '${widget.emptyLabel} ';
    } else if (items.length == 1) {
      return '${widget.itemTitle(items.first)} ';
    } else {
      if (widget.countLabel != null) {
        return '${widget.countLabel!(items.length)} ';
      }
      return '${items.length} items ';
    }
  }

  _DropdownState<T> _computeInitialState() {
    final initialList = List<T>.from(widget.initialSelectedItems);
    final initialIds = initialList.map(_getId).toSet();
    final isAll =
        widget.items.isNotEmpty && initialList.length == widget.items.length;

    return _DropdownState<T>(
      isAllSelected: isAll,
      selectedIds: initialIds,
      selectedItems: initialList,
      label: _deriveLabel(isAll, initialList),
    );
  }

  void _toggleMenu() => _isMenuOpen ? _closeMenu() : _openMenu();

  void _openMenu() {
    if (!mounted || _isMenuOpen) return;
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _arrowAnimController.forward();
    _isMenuOpen = true;
  }

  void _closeMenu() {
    if (!mounted || !_isMenuOpen) return;
    _removeOverlay();
    _arrowAnimController.reverse();
    _isMenuOpen = false;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSelectAll() {
    final current = _stateNotifier.value;
    final newIsAll = !current.isAllSelected;
    final newSelectedItems = newIsAll ? List<T>.from(widget.items) : <T>[];
    final newSelectedIds = newIsAll
        ? widget.items.map(_getId).toSet()
        : <String>{};

    _stateNotifier.value = _DropdownState<T>(
      isAllSelected: newIsAll,
      selectedIds: newSelectedIds,
      selectedItems: newSelectedItems,
      label: _deriveLabel(newIsAll, newSelectedItems),
    );

    widget.onChanged?.call(List.unmodifiable(newSelectedItems));
  }

  void _onToggleItem(T item) {
    final current = _stateNotifier.value;
    final id = _getId(item);

    if (!widget.isMultiSelect) {
      final newSelectedItems = [item];
      final newSelectedIds = {id};
      _stateNotifier.value = _DropdownState<T>(
        isAllSelected: false,
        selectedIds: newSelectedIds,
        selectedItems: newSelectedItems,
        label: _deriveLabel(false, newSelectedItems),
      );
      _closeMenu();
      widget.onChanged?.call(List.unmodifiable(newSelectedItems));
      return;
    }

    final newSelectedIds = Set<String>.from(current.selectedIds);
    final List<T> newSelectedItems;
    bool newIsAll = false;

    if (current.isAllSelected) {
      // User deselects this item from 'All'
      newSelectedIds.clear();
      newSelectedIds.addAll(
        widget.items.map(_getId).where((itemId) => itemId != id),
      );
      newSelectedItems = widget.items.where((i) => _getId(i) != id).toList();
    } else {
      if (newSelectedIds.contains(id)) {
        newSelectedIds.remove(id);
        newSelectedItems = current.selectedItems
            .where((i) => _getId(i) != id)
            .toList();
      } else {
        newSelectedIds.add(id);
        newSelectedItems = [...current.selectedItems, item];
        if (widget.items.isNotEmpty &&
            newSelectedIds.length == widget.items.length) {
          newIsAll = true;
        }
      }
    }

    _stateNotifier.value = _DropdownState<T>(
      isAllSelected: newIsAll,
      selectedIds: newSelectedIds,
      selectedItems: newSelectedItems,
      label: _deriveLabel(newIsAll, newSelectedItems),
    );

    widget.onChanged?.call(List.unmodifiable(newSelectedItems));
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final colors = context.colors;
    final effectiveWidth = widget.width ?? (1.sw - 32.w);

    return OverlayEntry(
      maintainState: false,
      builder: (overlayContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeMenu,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 6.h),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: effectiveWidth,
                constraints: BoxConstraints(maxHeight: widget.maxHeight.h),
                decoration: BoxDecoration(
                  color: colors.bgSecondary,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colors.borderTertiary, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: ValueListenableBuilder<_DropdownState<T>>(
                    valueListenable: _stateNotifier,
                    builder: (context, state, _) {
                      final hasSelectAll = widget.showSelectAll;
                      final totalCount =
                          widget.items.length + (hasSelectAll ? 1 : 0);

                      if (totalCount == 0) {
                        return Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Center(
                            child: CustomText(
                              text: 'No options available',
                              color: colors.textTertiary,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: totalCount,
                        itemBuilder: (ctx, index) {
                          // ── Index 0: Select All Row ──
                          if (hasSelectAll && index == 0) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: _onSelectAll,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 10.h,
                                    ),
                                    child: Row(
                                      children: [
                                        if (widget.selectAllIcon != null) ...[
                                          widget.selectAllIcon!,
                                          SizedBox(width: 12.w),
                                        ],
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomText(
                                                text: widget.selectAllTitle,
                                                fontWeight: state.isAllSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                                fontSize: 14.sp,
                                                color: state.isAllSelected
                                                    ? colors.primary
                                                    : colors.textPrimary,
                                              ),
                                              if (widget.selectAllSubtitle !=
                                                  null) ...[
                                                SizedBox(height: 2.h),
                                                CustomText(
                                                  text:
                                                      widget.selectAllSubtitle!,
                                                  fontSize: 12.sp,
                                                  color: colors.textTertiary,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          state.isAllSelected
                                              ? Icons.check_circle_rounded
                                              : Icons
                                                    .radio_button_unchecked_rounded,
                                          color: state.isAllSelected
                                              ? colors.primary
                                              : colors.iconSecondary,
                                          size: 20.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (widget.items.isNotEmpty)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: colors.borderSecondary,
                                  ),
                              ],
                            );
                          }

                          // ── Generic Items List (Virtualized) ──
                          final itemIndex = hasSelectAll ? index - 1 : index;
                          final item = widget.items[itemIndex];
                          final id = _getId(item);
                          final isSelected =
                              state.isAllSelected ||
                              state.selectedIds.contains(id);
                          final title = widget.itemTitle(item);
                          final subtitle = widget.itemSubtitle?.call(item);
                          final imageUrl = widget.itemImageUrl?.call(item);
                          final iconWidget = widget.itemIcon?.call(item);

                          return InkWell(
                            onTap: () => _onToggleItem(item),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                children: [
                                  if (imageUrl != null &&
                                      imageUrl.trim().isNotEmpty) ...[
                                    CustomNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 40.w,
                                      height: 40.h,
                                      borderRadius: 10.r,
                                      fallbackAsset: Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: colors.bgTertiary,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.restaurant_menu_rounded,
                                          color: colors.iconSecondary,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                  ] else if (iconWidget != null) ...[
                                    iconWidget,
                                    SizedBox(width: 12.w),
                                  ],
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomText(
                                          text: title,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: isSelected
                                              ? colors.primary
                                              : colors.textPrimary,
                                        ),
                                        if (subtitle != null &&
                                            subtitle.isNotEmpty) ...[
                                          SizedBox(height: 2.h),
                                          CustomText(
                                            text: subtitle,
                                            fontSize: 12.sp,
                                            color: colors.textTertiary,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: isSelected
                                        ? colors.primary
                                        : colors.iconSecondary,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: _toggleMenu,
          child: CustomContainer(
            bordersColor: context.colors.borderSecondary,
            radiusAll: 28.r,
            paddingVertical: 4.h,
            paddingHorizontal: 4.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomContainer(
                  paddingVertical: 8.h,
                  paddingHorizontal: 10.w,
                  radiusAll: 99.r,
                  color: context.colors.primary.withValues(alpha: 0.1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.selectAllIcon != null)
                        widget.selectAllIcon!
                      else
                        Icon(
                          Icons.grid_view_rounded,
                          color: context.colors.primary,
                          size: 16.sp,
                        ),
                      ValueListenableBuilder<_DropdownState<T>>(
                        valueListenable: _stateNotifier,
                        builder: (context, state, _) {
                          return CustomText(
                            left: 4.w,
                            fontWeight: FontWeight.w500,
                            color: context.colors.primary,
                            text: state.label,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                RotationTransition(
                  turns: _arrowAnimation,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.colors.primary,
                  ),
                ),
                SizedBox(width: 4.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
