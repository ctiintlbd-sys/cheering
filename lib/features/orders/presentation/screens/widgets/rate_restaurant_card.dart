import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/rating_stars_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateRestaurantCard extends StatelessWidget {
  const RateRestaurantCard({
    super.key,
    required this.restaurantName,
    this.restaurantLogoUrl,
    required this.tags,
    required this.selectedTags,
    required this.onTagToggle,
    required this.rating,
    required this.onRatingChanged,
    this.onCommentChanged,
    this.commentController,
  });

  final String restaurantName;
  final String? restaurantLogoUrl;
  final List<String> tags;
  final Set<String> selectedTags;
  final ValueChanged<String> onTagToggle;
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<String>? onCommentChanged;
  final TextEditingController? commentController;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colors.background,
      radiusAll: 16.r,
      paddingAll: 16.w,
      child: Column(
        children: [
          CustomNetworkImage(
            imageUrl: restaurantLogoUrl,
            width: 52.r,
            height: 52.r,
            borderRadius: 10.r,
          ),
          SizedBox(height: 12.w),
          CustomText(
            text: 'How was $restaurantName?',
            fontSize: 16.r,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.w),
          CustomText(
            text: 'Your feedback helps other customers and the restaurant',
            fontSize: 12.r,
            color: context.colors.textSecondary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.w),
          CustomText(
            text: 'What went well?',
            fontSize: 14.r,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.w),

          // Tags
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            runSpacing: 10.w,
            children: tags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return GestureDetector(
                onTap: () => onTagToggle(tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colors.primary.withValues(alpha: 0.08)
                        : context.colors.bgSecondary,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.borderTertiary,
                    ),
                  ),
                  child: CustomText(
                    text: tag,
                    fontSize: 12.r,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.w),
          RatingStarsRow(
            title: 'Rate restaurant',
            rating: rating,
            onChanged: onRatingChanged,
          ),
          SizedBox(height: 18.w),
          CustomTextField(
            controller: commentController,
            onChanged: onCommentChanged,
            labelBottom: 8.w,
            borderRadius: 12.r,
            validator: (_) => null,
            fillColor: context.colors.bgSecondary,
            minLines: 3,
            labelText: 'Leave a comment (optional)',
            hintText: 'Tell us what you liked or what could be better...',
          ),
        ],
      ),
    );
  }
}
