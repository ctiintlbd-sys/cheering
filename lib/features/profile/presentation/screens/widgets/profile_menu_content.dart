import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Modular Profile menu item tile widget.
class ProfileMenuContent extends StatelessWidget {
  final String title;
  final List<Widget> list;

  const ProfileMenuContent({
    super.key,
    required this.title,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            fontSize: 16.r,
            fontWeight: FontWeight.w600,
            bottom: 12.w,
            text: title,
          ),

          CustomContainer(
            radiusAll: 12.r,
            bordersColor: context.colors.borderTertiary,
            child: Column(children: list),
          ),
        ],
      ),
    );
  }
}
