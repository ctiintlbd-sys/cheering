import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingStarsRow extends StatelessWidget {
  const RatingStarsRow({
    super.key,
    required this.title,
    required this.rating,
    required this.onChanged,
  });

  final String title;
  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontWeight: FontWeight.w500,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            final isFilled = i < rating;
            return GestureDetector(
              onTap: () => onChanged(i + 1),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: AnimatedScale(
                  scale: isFilled ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Assets.icons.star.svg(
                    width: 22.r,
                    height: 22.r,
                    color: isFilled
                        ? context.colors.ratingColor
                        : context.colors.borderSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
