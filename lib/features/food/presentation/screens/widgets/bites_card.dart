import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';
import 'preview_video.dart';

class BitesCard extends StatelessWidget {
  const BitesCard({
    super.key,
    required this.reel,
    this.onTap,
  });

  final ReelEntity reel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = reel.thumbnailUrl?.isNotEmpty == true
        ? reel.thumbnailUrl!
        : (reel.restaurant.logoUrl ?? reel.restaurant.coverImageUrl ?? '');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 124.w,
        height: 176.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.colors.bgSecondary,
        ),
        clipBehavior: Clip.antiAlias,
        child: PreviewVideo(
          videoUrl: reel.videoUrl,
          placeholder: CustomNetworkImage(
            imageUrl: imageUrl,
            width: 124.w,
            height: 176.w,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
