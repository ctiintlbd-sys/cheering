import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme_colors.dart';

enum AddressMenuAction { edit, setDefault, delete }

Future<AddressMenuAction?> showAddressOptionsMenu({
  required BuildContext context,
  required Offset position,
  required bool isDefault,
}) {
  return showMenu<AddressMenuAction>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx - 160.w,
      position.dy + 8.h,
      position.dx,
      position.dy,
    ),
    elevation: 4,
    constraints: BoxConstraints(
      maxWidth: 200.w,
    ),
    shadowColor: context.colors.black.withValues(alpha: 0.04),
    color: context.colors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
      side: BorderSide(color: context.colors.borderTertiary),
    ),
    items: [
      _menuItem(
        context,
        value: AddressMenuAction.edit,
        icon: Icons.edit_outlined,
        label: 'Edit',
      ),
      if (!isDefault)
        _menuItem(
          context,
          value: AddressMenuAction.setDefault,
          icon: Icons.star_outline_rounded,
          label: 'Set as Default',
        ),
      _menuItem(
        context,
        value: AddressMenuAction.delete,
        icon: Icons.delete_outline_rounded,
        label: 'Delete',
        isDestructive: true,
      ),
    ],
  );
}

PopupMenuItem<AddressMenuAction> _menuItem(
  BuildContext context, {
  required AddressMenuAction value,
  required IconData icon,
  required String label,
  bool isDestructive = false,
}) {
  final color = isDestructive
      ? context.colors.error
      : context.colors.textPrimary;

  return PopupMenuItem(
    value: value,
    height: 48.h,
    child: Row(
      children: [
        Icon(icon, size: 20.r, color: color),
        SizedBox(width: 12.w),
        CustomText(
          text: label,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ],
    ),
  );
}
