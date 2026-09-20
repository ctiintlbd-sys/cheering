import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyAddressWidget extends StatelessWidget {
  const EmptyAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.emptyLocation.svg(),
          SizedBox(height: 44.w),
          CustomText(
            textAlign: TextAlign.center,
            text: 'No saved address',
            fontSize: 20.r,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 12.w),
          CustomText(
            text: 'Add your delivery address\nfor a faster checkout experience',
            fontSize: 16.r,
            color: context.colors.textTertiary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
