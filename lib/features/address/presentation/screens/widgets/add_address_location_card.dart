import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddressLocationCard extends StatelessWidget {
  const AddAddressLocationCard({
    super.key,
    required this.onChangeTap, required this.address,
  });

  final AddressEntity address;
  final VoidCallback onChangeTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onChangeTap,
      color: context.colors.bgSecondary,
      radiusAll: 12.r,
      paddingAll: 16.r,
      child: Row(
        children: [
          CustomContainer(
            alignment: Alignment.center,
            width: 32.r,
            height: 32.r,
            color: context.colors.primary.withValues(alpha: 0.10),
            radiusAll: 8.r,
            child: Assets.icons.foodLocation.svg(
              colorFilter: ColorFilter.mode(
                context.colors.primary,
                BlendMode.dstIn,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: address.city ?? 'Dhaka',
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                ),
                  CustomText(
                    top: 2.h,
                    text: address.formattedAddress,
                    fontSize: 12.sp,
                    color: context.colors.textTertiary,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          CustomText(
            onTap: onChangeTap,
            text: 'Change',
            fontWeight: FontWeight.w500,
            color: context.colors.primary,
          ),
        ],
      ),
    );
  }
}
