import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomLoader extends StatelessWidget {
  final double? top;
  final double? bottom;
  const CustomLoader({super.key, this.top, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: top ?? 0, bottom: bottom ?? 0),
      child: Center(
        child: CircularProgressIndicator(
          color: context.colors.primary,
          strokeWidth: 3.w,
        ),
      ),
    );
  }
}
