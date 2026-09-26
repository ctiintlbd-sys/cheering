import 'package:flutter/foundation.dart';

class OrderScheduleState {
  static String? restaurantId;
  static final ValueNotifier<DateTime?> scheduledForNotifier = ValueNotifier(null);

  static DateTime? get scheduledFor => scheduledForNotifier.value;

  static void setSchedule(String restId, DateTime time) {
    restaurantId = restId;
    scheduledForNotifier.value = time;
  }

  static void clear() {
    restaurantId = null;
    scheduledForNotifier.value = null;
  }
}
