import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuCategoryTabs extends StatefulWidget {
  final List<MenuCategoryEntity> categories;
  final ValueNotifier<int> activeIndexNotifier;
  final ValueChanged<int> onTabTapped;

  const MenuCategoryTabs({
    super.key,
    required this.categories,
    required this.activeIndexNotifier,
    required this.onTabTapped,
  });

  @override
  State<MenuCategoryTabs> createState() => _MenuCategoryTabsState();
}

class _MenuCategoryTabsState extends State<MenuCategoryTabs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.activeIndexNotifier.addListener(_onActiveIndexChanged);
  }

  @override
  void didUpdateWidget(covariant MenuCategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndexNotifier != widget.activeIndexNotifier) {
      oldWidget.activeIndexNotifier.removeListener(_onActiveIndexChanged);
      widget.activeIndexNotifier.addListener(_onActiveIndexChanged);
    }
  }

  @override
  void dispose() {
    widget.activeIndexNotifier.removeListener(_onActiveIndexChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onActiveIndexChanged() {
    if (!mounted) return;
    final index = widget.activeIndexNotifier.value;
    final offset =
        (index * 70.w) - (MediaQuery.of(context).size.width / 2) + 35.w;
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return SizedBox(height: 40.w);
    return CustomContainer(
      horizontalMargin: 16.w,
      height: 40.w,
      border: Border(bottom: BorderSide(color: context.colors.borderSecondary)),
      child: ValueListenableBuilder<int>(
        valueListenable: widget.activeIndexNotifier,
        builder: (context, selectedIndex, _) {
          return ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(width: 22.w),
            itemBuilder: (context, index) {
              final bool isSelected = selectedIndex == index;
              return CustomItemAnimator(
                index: index,
                child: GestureDetector(
                  onTap: () {
                    widget.onTabTapped(index);
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 8.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? context.colors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: CustomText(
                      text: widget.categories[index].name,
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.textSecondary,
                      fontSize: 14.r,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
