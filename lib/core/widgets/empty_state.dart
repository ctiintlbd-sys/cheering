import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? subMessage;
  final Widget? icon;
  final VoidCallback? onPressed;
  final String? buttonText;

  const EmptyState({super.key, this.message = 'No data found', this.subMessage, this.icon, this.onPressed, this.buttonText = 'Browse Food'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 100.w, horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Assets.images.empty.image(width: 258.w,height: 238.w),
            SizedBox(height: 16.w),
            CustomText(
              text: message,
              fontWeight: FontWeight.w600,
              fontSize: 20.w,
              textAlign: TextAlign.center,
            ),
            if (subMessage != null)
              CustomText(
                top: 4.w,
                text: subMessage!,
                color: context.colors.textTertiary,
                textAlign: TextAlign.center,
              ),
            if (onPressed != null)...[
              SizedBox(height: 24.w),
              CustomButton(
                width: 218.w,
                height: 48.w,
                onPressed: onPressed,
                text: buttonText,
              ),
            ],

          ],
        ),
      ),
    );
  }
}
