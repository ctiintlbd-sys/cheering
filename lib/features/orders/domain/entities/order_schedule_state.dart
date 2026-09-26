class OrderScheduleState {
  static String? restaurantId;
  static DateTime? scheduledFor;

  static void setSchedule(String restId, DateTime time) {
    restaurantId = restId;
    scheduledFor = time;
  }

  static void clear() {
    restaurantId = null;
    scheduledFor = null;
  }
}
