import 'package:flutter/material.dart';

class BottomSheetHelper {
  static void showCustomBottomSheet({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration transitionDuration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeOutExpo,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: "CustomBottomSheet",
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.5),
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(color: Colors.transparent, child: child),
        );
      },
      transitionBuilder:
          (context, animation, secondaryAnimation, animatedChild) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: curve,
                      reverseCurve: Curves.easeIn,
                    ),
                  ),
              child: animatedChild,
            );
          },
    );
  }
}
