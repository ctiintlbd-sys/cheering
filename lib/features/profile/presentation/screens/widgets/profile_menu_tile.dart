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

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.textColor,
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
          border: Border(
            bottom: BorderSide(
              color: context.colors.borderTertiary,
            ),
          ),
          height: 58.h,
          child: Row(
            children: [
              icon,
              SizedBox(width: 11.w),

              // Title
              Expanded(
                child: CustomText(
                  text: title,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? context.colors.textPrimary,
                ),
              ),

              // Trailing Chevron / Custom Widget
              Icon(
                Icons.chevron_right_rounded,
                size: 20.r,
                color: context.colors.iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
