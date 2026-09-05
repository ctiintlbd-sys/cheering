import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BitesCard extends StatelessWidget {
  const BitesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 130.w,
      height: 180.h,
      radiusAll: 16.r,
      clipBehavior: Clip.hardEdge,
      child: CustomNetworkImage(
        imageUrl: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5',
        boxShape: BoxShape.rectangle,
      ),
    );
  }
}
