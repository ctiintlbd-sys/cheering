import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';

class ReelsViewerArgs {
  final List<ReelEntity> reels;
  final int initialIndex;

  ReelsViewerArgs({
    required this.reels,
    this.initialIndex = 0,
  });
}
// ─── Auth Args ──────────────────────────────────────────────────────────

class OtpScreenArgs {
  final String email;
  final bool isForgotPassword;

  OtpScreenArgs({
    required this.email,
    this.isForgotPassword = false,
  });
}

class SetPasswordScreenArgs {
  final String email;
  final String otp;
  final bool isForgotPassword;

  SetPasswordScreenArgs({
    required this.email,
    required this.otp,
    this.isForgotPassword = false,
  });
}

class AboutScreenArgs {
  final String email;
  final String otp;
  final String password;

  AboutScreenArgs({
    required this.email,
    required this.otp,
    required this.password,
  });
}

// ─── Food Args ──────────────────────────────────────────────────────────

class RestaurantListArgs {
  final String title;
  final RestaurantQueryParams params;

  RestaurantListArgs({
    required this.title,
    required this.params,
  });
}

// ─── Cart Args ──────────────────────────────────────────────────────────

class OrderPlacedArgs {
  final String restaurantName;
  final int estimatedDeliveryMinutes;
  final String orderId;
  final String trackingOrderId;

  OrderPlacedArgs({
    required this.restaurantName,
    required this.estimatedDeliveryMinutes,
    required this.orderId,
    this.trackingOrderId = '',
  });
}

// ─── Orders Args ─────────────────────────────────────────────────────────

class RateOrderArgs {
  final String orderId;
  final String restaurantName;
  final String? restaurantLogoUrl;
  final bool hasRider;
  final String? riderName;
  final String? riderPhotoUrl;
  final double? riderRating;
  final int deliveryMinutes;

  const RateOrderArgs({
    this.orderId = '',
    this.restaurantName = 'KFC - Badda',
    this.restaurantLogoUrl,
    this.hasRider = true,
    this.riderName = 'Jayed Khan',
    this.riderPhotoUrl,
    this.riderRating = 4.9,
    this.deliveryMinutes = 24,
  });

  factory RateOrderArgs.fromOrder(dynamic order) {
    if (order == null) return const RateOrderArgs();

    String name = 'KFC - Badda';
    String? logo;
    String id = '';
    
    bool hasRider = false;
    String? riderName;
    String? riderPhotoUrl;
    double? riderRating;
    int deliveryMinutes = 24;

    try {
      final orderName = order.restaurantName?.toString();
      if (orderName != null && orderName.isNotEmpty) {
        name = orderName;
      }
      logo = order.restaurantLogoUrl?.toString();
      id = order.id?.toString() ?? '';

      try {
        if (order.deliveredAt != null && order.placedAt != null) {
          final diff = (order.deliveredAt as DateTime).difference(order.placedAt as DateTime);
          deliveryMinutes = diff.inMinutes > 0 ? diff.inMinutes : 24;
        }
      } catch (_) {}

      try {
        final riderData = order.rider;
        if (riderData != null) {
          hasRider = true;
          if (riderData is Map) {
            riderName = riderData['full_name']?.toString() ?? 'Rider';
            riderPhotoUrl = riderData['avatar_url']?.toString();
            final rAvg = riderData['rating_avg'];
            if (rAvg != null) {
              riderRating = double.tryParse(rAvg.toString()) ?? 5.0;
            } else {
              riderRating = 5.0;
            }
          } else {
            try { riderName = riderData.fullName?.toString() ?? riderData.name?.toString() ?? 'Rider'; } catch (_) {}
            try { riderPhotoUrl = riderData.avatarUrl?.toString() ?? riderData.photoUrl?.toString(); } catch (_) {}
            try { riderRating = double.tryParse(riderData.ratingAvg?.toString() ?? '5.0'); } catch (_) {}
          }
        }
      } catch (_) {}
    } catch (_) {}

    return RateOrderArgs(
      orderId: id,
      restaurantName: name,
      restaurantLogoUrl: logo,
      hasRider: hasRider,
      riderName: riderName ?? (hasRider ? 'Rider' : null),
      riderPhotoUrl: riderPhotoUrl,
      riderRating: riderRating ?? (hasRider ? 5.0 : null),
      deliveryMinutes: deliveryMinutes,
    );
  }
}
