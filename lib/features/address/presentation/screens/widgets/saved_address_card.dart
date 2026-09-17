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
  const SavedAddressCard({
    super.key,
    required this.address,
    this.title,
    this.onSetDefault,
  });

  final AddressEntity address;
  final String? title;
  final VoidCallback? onSetDefault;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSetDefault?.call();
        if (address.id != 'current_location' && !address.isDefault) {
          context.read<AddressBloc>().add(SetDefaultAddressRequested(address.id));
        }
      },
      child: CustomContainer(
        color: context.colors.background,
      bordersColor: context.colors.borderTertiary,
      radiusAll: 16.r,
      paddingVertical: 12.h,
      paddingHorizontal: 16.w,
      boxShadow: [
        if (address.isDefault)
          BoxShadow(
            color: context.colors.black.withValues(alpha: 0.04),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
      ],
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
                    CustomText(
                      text: title ?? address.type.name,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
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
                  text: _getFullAddress(address),
                  color: context.colors.textTertiary,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (address.id != 'current_location') ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTapDown: (details) =>
                  _onAddressMenu(context, details.globalPosition),
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
    ));
  }

  String _getFullAddress(AddressEntity address) {
    final parts = <String>[];
    if (address.streetAddress?.isNotEmpty == true) {
      parts.add(address.streetAddress!);
    }
    if (address.apartment?.isNotEmpty == true) parts.add(address.apartment!);
    if (address.landmark?.isNotEmpty == true) parts.add(address.landmark!);
    if (address.city?.isNotEmpty == true) {
      if (!parts.any(
        (p) => p.toLowerCase().contains(address.city!.toLowerCase()),
      )) {
        parts.add(address.city!);
      }
    }
    final addressText = parts.isNotEmpty
        ? parts.join(', ')
        : (address.label ?? '');
    return addressText;
  }

  Future<void> _onAddressMenu(BuildContext context, Offset position) async {
    final action = await showAddressOptionsMenu(
      context: context,
      position: position,
      isDefault: address.isDefault,
    );
    if (action == null || !context.mounted) return;

    final bloc = context.read<AddressBloc>();
    switch (action) {
      case AddressMenuAction.edit:
        final saved = await context.push<bool>(
          RoutePaths.addAddress,
          extra: address,
        );
        if (saved == true && context.mounted) {
          context.read<AddressBloc>().add(const RefreshAddressesRequested());
        }
      case AddressMenuAction.setDefault:
        onSetDefault?.call();
        bloc.add(SetDefaultAddressRequested(address.id));
      case AddressMenuAction.delete:
        bloc.add(DeleteAddressRequested(address.id));
    }
  }
}
