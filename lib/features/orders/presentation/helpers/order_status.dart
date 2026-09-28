import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';

abstract final class OrderStatus {
  static (String, Color) badge(BuildContext context, String status) {
    return switch (status.toUpperCase()) {
      'PENDING' => ('Pending', context.colors.primary),
      'PREPARING' => ('Preparing', context.colors.bgWarningSecondary),
      'READY' => ('Ready', context.colors.bgInfoPrimary),
      'PICKED_UP' => ('Picked up', context.colors.bgWarningSecondary),
      'DELIVERED' => ('Delivered', context.colors.bgSuccessSecondary),
      'CANCELLED' => ('Cancelled', context.colors.bgErrorSecondary),
      _ => (status, context.colors.primary),
    };
  }
}
