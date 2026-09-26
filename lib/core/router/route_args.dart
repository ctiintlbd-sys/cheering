import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';

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
