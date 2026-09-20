import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';

class CustomMenuContainer extends StatefulWidget {
  final Widget child;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final double? dropdownWidth;
  final double dropdownMaxHeight;
  final double dropdownBorderRadius;

  const CustomMenuContainer({
    super.key,
    required this.child,
    required this.items,
    required this.onSelected,
    this.dropdownWidth,
    this.dropdownMaxHeight = 250,
    this.dropdownBorderRadius = 10,
  });

  @override
  State<CustomMenuContainer> createState() => _CustomMenuContainerState();
}

class _CustomMenuContainerState extends State<CustomMenuContainer> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  void _toggleMenu() {
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (_isMenuOpen) return;
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isMenuOpen = true);
  }

  void _closeMenu() {
    if (!_isMenuOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isMenuOpen = false);
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final effectiveWidth = widget.dropdownWidth ?? size.width;
    final horizontalOffset =
        (widget.dropdownWidth != null && widget.dropdownWidth! > size.width)
        ? -(widget.dropdownWidth! - size.width)
        : 0.0;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeMenu,
              child: const ColoredBox(color: Colors.transparent),
            ),
            Positioned(
              width: effectiveWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(horizontalOffset, size.height + 4.w),
                child: Material(
                  color: Colors.transparent,
                  child: _MenuContent(
                    items: widget.items,
                    width: effectiveWidth,
                    maxHeight: widget.dropdownMaxHeight,
                    borderRadius: widget.dropdownBorderRadius,
                    onSelected: (item) {
                      widget.onSelected(item);
                      _closeMenu();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: widget.child,
      ),
    );
  }
}

class _MenuContent extends StatelessWidget {
  const _MenuContent({
    required this.items,
    required this.width,
    required this.maxHeight,
    required this.borderRadius,
    required this.onSelected,
  });

  final List<String> items;
  final double width;
  final double maxHeight;
  final double borderRadius;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 17,
          ),
        ],
        color: colors.background,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colors.borderTertiary),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: items.isEmpty
            ? Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'No options available',
                  style: TextStyle(
                    color: colors.textPlaceholder,
                    fontSize: 14.sp,
                    fontFamily: FontFamily.sFPro,
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 6.w),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: colors.borderTertiary,
                ),
                itemBuilder: (ctx, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => onSelected(item),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
                      child: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.sFPro,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
