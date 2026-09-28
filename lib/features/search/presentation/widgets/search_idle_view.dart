import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchIdleView extends StatelessWidget {
  const SearchIdleView({
    super.key,
    required this.recentSearches,
    required this.onRecentTap,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onRecentTap;

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Recent searches',
            fontWeight: FontWeight.w600,
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
