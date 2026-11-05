import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FoodFlexibleBackground extends StatelessWidget {
  const FoodFlexibleBackground({
    super.key,
    required this.imageUrl,
    this.mediaType,
    this.fallbackAsset,
  });

  final String imageUrl;
  final String? mediaType;
  final Widget? fallbackAsset;

  bool get _isLottie =>
      mediaType?.toUpperCase() == 'LOTTIE' ||
      imageUrl.toLowerCase().endsWith('.json');

  @override
  Widget build(BuildContext context) {
    final defaultFallback =
        fallbackAsset ??
        Assets.lotties.banner.lottie(
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );

    final Widget content;
    if (_isLottie && imageUrl.isNotEmpty) {
      content = Lottie.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => defaultFallback,
      );
    } else {
      content = CustomNetworkImage(
        imageUrl: imageUrl,
        fallbackAsset: defaultFallback,
      );
    }

    return CustomContainer(
      height: 300.w,
      bottomRight: 20.w,
      bottomLeft: 20.w,
      paddingBottom: 24.w,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.w),
          bottomLeft: Radius.circular(20.w),
        ),
        child: content,
      ),
    );
  }
}
