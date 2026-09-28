import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/features/food/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchCategoryChips extends StatelessWidget {
  const SearchCategoryChips({
    super.key,
    required this.categories,
    required this.activeQuery,
    required this.onCategoryTap,
  });

  final List<CategoryEntity> categories;
  final String activeQuery;
  final ValueChanged<CategoryEntity> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final query = activeQuery.trim().toLowerCase();

    return SizedBox(
      height: 40.w,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = query.isNotEmpty &&
              category.name.toLowerCase() == query;

          return CustomFilterChip(
            label: category.name,
            isSelected: isActive,
            onTap: () => onCategoryTap(category),
          );
        },
      ),
    );
  }
}
