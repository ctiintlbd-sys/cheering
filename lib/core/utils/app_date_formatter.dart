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
    return DateFormat('hh:mm a').format(date);
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
  static String formatRemainingTime(Duration duration) {
    if (duration.isNegative) return '0:00';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}';
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
}
