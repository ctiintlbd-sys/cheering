import 'package:intl/intl.dart';

class AppDateFormatter {
  AppDateFormatter._();

  /// Format: 14 Aug
  static String formatDayMonth(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  /// Format: 14 Aug 2026
  static String formatDayMonthYear(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format: Mon, Tue, etc.
  static String formatShortDay(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  /// Format String date to short day: '2026-08-14' -> 'Fri'
  static String formatShortDayFromString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    final date = DateTime.tryParse(dateStr) ?? DateTime.now();
    return formatShortDay(date);
  }

  /// Format: 10:30 AM
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date.toUtc());
  }

  /// Format '14:30' -> '2:30 PM'
  static String format24HourTime(String time) {
    if (time.isEmpty) return '10:00 AM';
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time;
    }
  }

  /// Format: 14 Aug 2026, 10:30 AM
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  /// Format: 2026-08-14
  static String formatIsoDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format: Monday, 14 Aug
  static String formatDayNameMonth(DateTime date) {
    return DateFormat('EEEE, dd MMM').format(date);
  }

  /// Relative Time: Just now, 2 hours ago, Yesterday, etc.
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDayMonthYear(date);
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return '1 hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return '1 minute ago';
    } else {
      return 'Just now';
    }
  }

  /// Format remaining time: 9:20 (Hours:Minutes)
  static String formatRemainingTime(DateTime? scheduledFor) {
    if (scheduledFor == null) return 'Now';
    final duration = scheduledFor.toUtc().difference(DateTime.now().toUtc());

    if (duration.inMinutes <= 0) return 'Now';

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) return '${days}d ${hours}Hours';
    if (hours > 0) return '${hours}h ${minutes}Mins';
    return '${minutes}Mins';
  }
  /// Duration format: 02:30 (Minutes:Seconds)
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Format Schedule Time: Today, 10:30 AM | Tomorrow, 10:30 AM | 14 Aug, 10:30 AM
  static String formatScheduleTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);
    
    final timeStr = formatTime(date);

    if (targetDate == today) {
      return 'Today, $timeStr';
    } else if (targetDate == tomorrow) {
      return 'Tomorrow, $timeStr';
    } else {
      return '${formatDayMonth(date)}, $timeStr';
    }
  }

  /// Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // --- Scheduling Utility Methods ---

  static String getWeekdayKey(int weekday) {
    switch (weekday) {
      case 1: return 'mon';
      case 2: return 'tue';
      case 3: return 'wed';
      case 4: return 'thu';
      case 5: return 'fri';
      case 6: return 'sat';
      case 7: return 'sun';
      default: return 'mon';
    }
  }

  static List<DateTime> generateDates(Map<String, dynamic> businessHours) {
    List<DateTime> availableDates = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String key = getWeekdayKey(date.weekday);
      if (businessHours.containsKey(key)) {
        var hours = businessHours[key]!;
        if (hours.isOpen) {
          availableDates.add(date);
        }
      }
    }
    return availableDates;
  }

  static List<DateTime> generateTimesForDate(DateTime date, Map<String, dynamic> businessHours) {
    List<DateTime> newTimes = [];
    String key = getWeekdayKey(date.weekday);
    var hours = businessHours[key];

    if (hours != null && hours.isOpen && hours.opensAt != null && hours.closesAt != null) {
      List<String> openParts = hours.opensAt.split(':');
      List<String> closeParts = hours.closesAt.split(':');

      if (openParts.length >= 2 && closeParts.length >= 2) {
        int openHour = int.parse(openParts[0]);
        int openMin = int.parse(openParts[1]);
        int closeHour = int.parse(closeParts[0]);
        int closeMin = int.parse(closeParts[1]);

        DateTime startTime = DateTime(date.year, date.month, date.day, openHour, openMin);
        DateTime endTime = DateTime(date.year, date.month, date.day, closeHour, closeMin);

        DateTime now = DateTime.now();

        if (startTime.isBefore(now)) {
          int min = now.minute;
          if (min < 30) {
            startTime = DateTime(now.year, now.month, now.day, now.hour, 30);
          } else {
            startTime = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
          }
        }

        while (startTime.isBefore(endTime)) {
          DateTime nextTime = startTime.add(const Duration(minutes: 30));
          if (nextTime.isAfter(endTime)) break;

          newTimes.add(startTime);
          startTime = nextTime;
        }
      }
    }
    
    return newTimes;
  }

  static String formatSheetTime(DateTime time) {
    int h = time.hour;
    int m = time.minute;
    String ampm = h >= 12 ? 'PM' : 'AM';
    if (h > 12) h -= 12;
    if (h == 0) h = 12;
    return '$h:${m.toString().padLeft(2, '0')} $ampm';
  }

  static String formatSheetDate(DateTime date) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }

  static String getSheetDayName(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    DateTime tomorrow = now.add(const Duration(days: 1));
    if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
