import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CartBottomBarWidget extends StatelessWidget {
  const CartBottomBarWidget({
    super.key,
    required this.totalPrice,
    this.buttonText = 'Processed to checkout',
    this.onPressed,
  });
  
  final double totalPrice;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      paddingHorizontal: 16.w,
      paddingVertical: 8.w,
      color: context.colors.background,
      border: Border(top: BorderSide(color: context.colors.borderSecondary)),
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.13),
          blurRadius: 13,
          offset: const Offset(0, -1),
        ),
      ],
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              paddingVertical: 12.w,
              paddingHorizontal: 16.w,
              boxShadow: [
                BoxShadow(
                  color: context.colors.black.withValues(alpha: 0.02),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        height: 1.6,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.sFPro,
                        color: context.colors.textPrimary,
                      ),
                      children: [
                        TextSpan(text: 'Total '),
                        TextSpan(
                          text: '(Including fee, taxes)\n',
                          style: TextStyle(
                            fontSize: 12.r,
                            fontWeight: FontWeight.w400,
                            color: context.colors.textTertiary,
                          ),
                        ),
                        TextSpan(
                          text: 'View details billings',
                          style: TextStyle(
                            fontSize: 12.r,
                            fontWeight: FontWeight.w400,
                            color: context.colors.textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  CustomText(
                    text: '৳${totalPrice.toStringAsFixed(0)}',
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                    color: context.colors.primary,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.w),
            CustomButton(
              text: buttonText,
              onPressed: onPressed ?? () => context.push(RoutePaths.checkout),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
