import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressActionButtons extends StatelessWidget {
  final VoidCallback onTapCurrentLocation;
  final VoidCallback onTapEnterManually;

  const AddressActionButtons({
    super.key,
    required this.onTapCurrentLocation,
    required this.onTapEnterManually,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Assets.icons.currentLocation.svg(),
            label: 'Use current location',
            onTap: onTapCurrentLocation,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Assets.icons.manualLocation.svg(),
            label: 'Enter Manually',
            onTap: onTapEnterManually,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return CustomContainer(
      color: context.colors.background,
      radiusAll: 12.r,
      bordersColor: context.colors.bgTertiary,
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
        ),
      ],
      paddingAll: 12.r,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(height: 12.h),
          CustomText(text: label, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
