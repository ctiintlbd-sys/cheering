import 'package:cheering/core/helpers/map_marker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManualAddressMapPin extends StatelessWidget {
  const ManualAddressMapPin({super.key, required this.isMoving});

  final bool isMoving;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(bottom: 35.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, isMoving ? -15 : 0, 0),
          child: MapMarkerHelper.buildLocationPinOverlay(
            width: 64.w,
            height: 64.h,
          ),
        ),
      ),
    );
  }
}
