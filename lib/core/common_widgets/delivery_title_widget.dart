import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/custom_container.dart';
import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_state.dart';
import 'package:cheering/features/address/domain/entities/address_entity.dart';

class DeliveryTitleWidget extends StatelessWidget {
  const DeliveryTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCircularIconButton(
          context: context,
          icon: Assets.icons.foodLocation.svg(),
          backgroundColor: context.colors.white.withValues(alpha: 0.15),
          onTap: () {
            context.push(RoutePaths.address);
          },
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                textAlign: TextAlign.start,
                text: 'Delivery to',
                fontSize: 12.r,
                fontWeight: FontWeight.w500,
                color: context.colors.white.withValues(alpha: 0.8),
              ),
              BlocSelector<AddressBloc, AddressState, String>(
                selector: (state) =>
                    state.activeAddress?.formattedAddress ??
                    'Getting location...',
                builder: (context, addressText) {
                  return CustomText(
                    top: 2.w,
                    textAlign: TextAlign.start,
                    text: addressText,
                    fontSize: 12.r,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    color: context.colors.white.withValues(alpha: 0.8),
                  );
                },
              ),
            ],
          ),
        ),
        _buildCircularIconButton(
          context: context,
          icon: Assets.icons.foodLove.svg(),
          backgroundColor: context.colors.white.withValues(alpha: 0.15),
          onTap: () {},
        ),
        SizedBox(width: 12.w),
        _buildCircularIconButton(
          context: context,
          icon: Assets.icons.cart.svg(),
          backgroundColor: context.colors.white,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCircularIconButton({
    required BuildContext context,
    required Widget icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return CustomContainer(
      onTap: onTap,
      shape: BoxShape.circle,
      width: 44.r,
      height: 44.r,
      color: backgroundColor,
      boxShadow: [
        BoxShadow(
          offset: const Offset(-2, 2),
          blurRadius: 16,
          color: context.colors.black.withValues(alpha: 0.04),
        ),
      ],
      alignment: Alignment.center,
      child: icon,
    );
  }
}
