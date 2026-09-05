import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/custom_container.dart';
import 'package:cheering/core/widgets/custom_network_image.dart';
import 'package:cheering/core/widgets/custom_text_field.dart';
import 'package:cheering/features/food/presentation/screens/widgets/delivery_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;

  FoodSliverHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Calculate how much the header is collapsed (0.0 to 1.0)
    final progress = shrinkOffset / (maxExtent - minExtent);
    // Opacity for fading out the background and title (disappears faster)
    final opacity = (1 - progress * 1.5).clamp(0.0, 1.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Background Image and Banner Container (Fades out on scroll)
        Opacity(
          opacity: opacity,
          child: CustomContainer(
            height: expandedHeight, // Adjust based on your design, original was 276.h
            bottomRight: 20.h,
            bottomLeft: 20.h,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.h),
                bottomLeft: Radius.circular(20.h),
              ),
              child: CustomNetworkImage(
                imageUrl: '',
                fallbackAsset: Assets.images.foodBanner.image(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // 2. Title Widget (Fades out on scroll)
        Positioned(
          top: MediaQuery.of(context).padding.top + 10.h,
          left: 16.w,
          right: 16.w,
          child: Opacity(
            opacity: opacity,
            child: const DeliveryTitleWidget(address: 'House 25, Banani Rd 11...'),
          ),
        ),

        // 3. Search Bar (Moves up and stays pinned)
        Positioned(
          left: 16.w,
          right: 16.w,
          // Calculate the bottom position: starts at 0, moves up to center in collapsed height
          bottom: 0.h + (progress * ((collapsedHeight / 2) - 24.h)), 
          child: CustomTextField(
            onTap: () {},
            readOnly: true,
            prefixIcon: Assets.icons.search.svg(),
            suffixIcon: Assets.icons.filtter.svg(),
            borderRadius: 99.r,
            fillColor: context.colors.background,
            borderColor: context.colors.borderSecondary,
            hintText: 'Search food...',
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
