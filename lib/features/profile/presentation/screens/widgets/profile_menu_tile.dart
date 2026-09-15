import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Modular Profile menu item tile widget.
class ProfileMenuTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? bgColor;
  final bool isBorder;
  final bool isTrailing;
  final Widget? trailingWidget;

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.textColor,
    this.isBorder = true,
    this.isTrailing = true,
    this.bgColor,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        child: CustomContainer(
          radiusAll: 12.r,
          color: bgColor,
          border: isBorder
              ? Border(bottom: BorderSide(color: context.colors.borderTertiary))
              : null,
          height: 58.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                icon,
                SizedBox(width: 11.w),
                Expanded(
                  child: CustomText(
                    text: title,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? context.colors.textPrimary,
                  ),
                ),
                if (trailingWidget != null)
                  trailingWidget!
                else if (isTrailing)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20.r,
                    color: context.colors.iconSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
