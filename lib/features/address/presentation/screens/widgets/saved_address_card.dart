import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme_colors.dart';
import '../../../domain/entities/address_entity.dart';
import '../../utils/address_display.dart';

class SavedAddressCard extends StatelessWidget {
  const SavedAddressCard({
    super.key,
    required this.address,
    required this.onMenuTap,
  });

  final AddressEntity address;
  final void Function(Offset position) onMenuTap;

  @override
  Widget build(BuildContext context) {
    final line1 = address.subtitleLine1;
    final line2 = address.subtitleLine2;

    return CustomContainer(
      color: context.colors.background,
      radiusAll: 16.r,
      paddingAll: 16.r,
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.06),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DefaultIndicator(isDefault: address.isDefault),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: address.titleLabel,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    if (address.isDefault) ...[
                      SizedBox(width: 8.w),
                      CustomContainer(
                        paddingHorizontal: 8.w,
                        paddingVertical: 2.h,
                        color: context.colors.primary.withValues(alpha: 0.12),
                        radiusAll: 99,
                        child: CustomText(
                          text: 'Default',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
                if (line1.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  CustomText(
                    text: line1,
                    fontSize: 14.sp,
                    color: context.colors.textSecondary,
                    maxLines: 2,
                  ),
                ],
                if (line2.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  CustomText(
                    text: line2,
                    fontSize: 14.sp,
                    color: context.colors.textSecondary,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Material(
            color: context.colors.bgSecondary,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTapDown: (details) =>
                  onMenuTap(details.globalPosition),
              child: SizedBox(
                width: 36.r,
                height: 36.r,
                child: Icon(
                  Icons.more_horiz,
                  size: 20.r,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultIndicator extends StatelessWidget {
  const _DefaultIndicator({required this.isDefault});

  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
        width: 20.r,
        height: 20.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDefault
                ? context.colors.primary
                : context.colors.bgTertiary,
            width: isDefault ? 6 : 1.5,
          ),
        ),
      ),
    );
  }
}
