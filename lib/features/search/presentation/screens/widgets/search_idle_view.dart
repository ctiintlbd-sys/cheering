import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchIdleView extends StatelessWidget {
  const SearchIdleView({
    super.key,
    required this.recentSearches,
    required this.onRecentTap,
    this.onClearTap,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onRecentTap;
  final VoidCallback? onClearTap;

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: 'Recent searches',
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: 'Clear',
                fontSize: 12.w,
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
                onTap: onClearTap,
              ),
            ],
          ),
          SizedBox(height: 12.w),
          CustomContainer(
            radiusAll: 16.r,
            color: context.colors.background,
            bordersColor: context.colors.borderTertiary,
            child: Column(
              children: [
                for (var index = 0; index < recentSearches.length; index++) ...[
                  if (index > 0)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: context.colors.borderTertiary,
                    ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onRecentTap(recentSearches[index]),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.w,
                        ),
                        child: CustomText(
                          text: recentSearches[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
