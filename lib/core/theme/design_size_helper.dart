import 'package:flutter/material.dart';

class DesignSizeHelper {
  DesignSizeHelper._();

  static Size getDesignSize() {
    final window =
        WidgetsBinding.instance.platformDispatcher.views.first;
    final size = window.physicalSize / window.devicePixelRatio;

    final designWidth = size.width.clamp(375.0, 430.0);  // ✅ 360 → 375
    final designHeight = size.height.clamp(667.0, 932.0); // ✅ 720 → 667

    return Size(designWidth, designHeight);
  }
}
