import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_event.dart';
import 'package:cheering/features/address/presentation/screens/widgets/address_options_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/address_entity.dart';

class SavedAddressCard extends StatelessWidget {
  const SavedAddressCard({super.key, required this.address, this.onSetDefault});

  final AddressEntity address;
  final VoidCallback? onSetDefault;

  bool get _isCurrentLocation => address.isCurrentLocation;

  String get _displayTitle =>
      _isCurrentLocation ? 'Current Location' : address.type.name.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSetDefault?.call();
        if (!_isCurrentLocation && !address.isDefault) {
          context.read<AddressBloc>().add(
            SetDefaultAddressRequested(address.id),
          );
        }
      },
      child: CustomContainer(
        color: context.colors.background,
        bordersColor: context.colors.borderTertiary,
        radiusAll: 16.r,
        paddingVertical: 12.h,
        paddingHorizontal: 16.w,
        boxShadow: address.isDefault
            ? [
                BoxShadow(
                  color: context.colors.black.withValues(alpha: 0.04),
                  blurRadius: 7,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              alignment: Alignment.center,
              width: 24.r,
              height: 24.r,
              shape: BoxShape.circle,
              bordersColor: address.isDefault
                  ? context.colors.primary
                  : context.colors.bgTertiary,
              borderWidth: address.isDefault ? 2.r : 1.6.r,
              child: address.isDefault
                  ? CustomContainer(
                      height: 14.r,
                      width: 14.r,
                      shape: BoxShape.circle,
                      color: context.colors.primary,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: CustomText(
                          text: _displayTitle,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (address.isDefault) ...[
                        SizedBox(width: 8.w),
                        CustomContainer(
                          paddingHorizontal: 12.w,
                          paddingVertical: 2.h,
                          color: context.colors.primary.withValues(alpha: 0.1),
                          radiusAll: 36.r,
                          child: CustomText(
                            text: 'Default',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: address.formattedAddress,
                    color: context.colors.textTertiary,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            if (!_isCurrentLocation) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTapDown: (details) =>
                    _showAddressMenu(context, details.globalPosition),
                child: CustomContainer(
                  radiusAll: 12.r,
                  paddingAll: 10.r,
                  color: context.colors.bgSecondary,
                  child: Icon(
                    Icons.more_horiz,
                    size: 20.r,
                    color: context.colors.iconPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showAddressMenu(BuildContext context, Offset position) async {
    final action = await showAddressOptionsMenu(
      context: context,
      position: position,
      isDefault: address.isDefault,
    );

    if (action == null || !context.mounted) return;

    final bloc = context.read<AddressBloc>();

    switch (action) {
      case AddressMenuAction.edit:
        await context.push<bool>(RoutePaths.addAddress, extra: address);
      case AddressMenuAction.setDefault:
        onSetDefault?.call();
        bloc.add(SetDefaultAddressRequested(address.id));
      case AddressMenuAction.delete:
        if (address.isDefault) {
          ToastMessageHelper.show(
            'Set another address as default before deleting this one',
          );
          return;
        }
        bloc.add(DeleteAddressRequested(address.id));
    }
  }
}
