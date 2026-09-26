import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/order_tracking_entity.dart';

class TrackingStep {
  final String status;
  final String title;
  final Widget icon;

  const TrackingStep({
    required this.status,
    required this.title,
    required this.icon,
  });
}

abstract final class TrackingStatus {
  static const pending = 'PENDING';
  static const preparing = 'PREPARING';
  static const ready = 'READY';
  static const outForDelivery = 'OUT_FOR_DELIVERY';
  static const delivered = 'DELIVERED';

  static final steps = [
     TrackingStep(
      status: pending,
      title: 'Order placed',
      icon: Assets.icons.statusOrder.svg(),
    ),
    TrackingStep(
      status: preparing,
      title: 'Preparing your order',
      icon: Assets.icons.statusPerpating.svg(),
    ),
     TrackingStep(
      status: outForDelivery,
      title: 'Rider picked up order',
       icon: Assets.icons.statusRider.svg(),
    ),
     TrackingStep(
      status: delivered,
      title: 'Delivered',
      icon: Icon(Icons.check,color: Colors.white,size: 20.w),
    ),
  ];

  static String normalize(String status) {
    switch (status.toUpperCase()) {
      case 'PICKED_UP':
      case 'ON_THE_WAY':
      case 'OUT_FOR_DELIVERY':
        return outForDelivery;
      default:
        return status.toUpperCase();
    }
  }

  static int progressIndex(String status) {
    switch (normalize(status)) {
      case pending:
        return 0;
      case preparing:
      case ready:
        return 1;
      case outForDelivery:
        return 2;
      case delivered:
        return 3;
      default:
        return 0;
    }
  }

  static String title(OrderTrackingEntity tracking) {
    if (normalize(tracking.status) == delivered) return 'Delivered';
    final minutes = tracking.etaMinutes;
    if (minutes != null && minutes > 0) {
      return 'Arriving in $minutes minutes';
    }
    return switch (normalize(tracking.status)) {
      pending => 'Order placed',
      preparing => 'Preparing your order',
      ready => 'Your order is ready',
      outForDelivery => 'On the way',
      _ => 'Order update',
    };
  }

  static String subtitle(OrderTrackingEntity tracking) {
    return switch (normalize(tracking.status)) {
      pending =>
        '${tracking.restaurantName} received your order.',
      preparing =>
        '${tracking.restaurantName} is preparing your order.',
      ready =>
        'Your order is ready. A rider will pick it up soon.',
      outForDelivery =>
        'Your order on the way. get ready to enjoy your food',
      delivered => 'Your order has been delivered. Enjoy your food!',
      _ => 'We are updating your order.',
    };
  }

  static DateTime? timeForStep(
    String stepStatus,
    List<TrackingTimelineEntity> timeline,
  ) {
    final aliases = switch (stepStatus) {
      outForDelivery => const [
          'OUT_FOR_DELIVERY',
          'PICKED_UP',
          'ON_THE_WAY',
        ],
      _ => [stepStatus],
    };

    for (final item in timeline) {
      if (aliases.contains(item.status.toUpperCase())) return item.at;
    }
    return null;
  }
}
