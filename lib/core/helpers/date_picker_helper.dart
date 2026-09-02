import 'package:flutter/material.dart';
import 'package:cheering/core/theme/app_theme_colors.dart';

// ─── BuildContext Extension — Public API ──────────────────────────────────────

extension DatePickerExtension on BuildContext {
  /// Picks a single date with theme styling and optional callback.
  Future<DateTime?> pickDate({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime>? onDatePicked,
  }) async {
    return DatePickerHelper.pickDate(
      context: this,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onDatePicked: onDatePicked,
    );
  }

  /// Picks a date range with theme styling and optional callback.
  Future<DateTimeRange?> pickDateRange({
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTimeRange>? onDateRangePicked,
  }) async {
    return DatePickerHelper.pickDateRange(
      context: this,
      initialDateRange: initialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
      onDateRangePicked: onDateRangePicked,
    );
  }

  /// Picks a time with theme styling and optional callback.
  Future<TimeOfDay?> pickTime({
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay>? onTimePicked,
  }) async {
    return DatePickerHelper.pickTime(
      context: this,
      initialTime: initialTime,
      onTimePicked: onTimePicked,
    );
  }
}

// ─── Facade Class ─────────────────────────────────────────────────────────────

class DatePickerHelper {
  DatePickerHelper._();

  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime>? onDatePicked,
  }) async {
    final now = DateTime.now();
    final colors = context.colors;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: colors.white,
              surface: colors.bgSecondary,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      onDatePicked?.call(picked);
    }
    return picked;
  }

  static Future<DateTimeRange?> pickDateRange({
    required BuildContext context,
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTimeRange>? onDateRangePicked,
  }) async {
    final colors = context.colors;

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: colors.white,
              surface: colors.bgSecondary,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      onDateRangePicked?.call(picked);
    }
    return picked;
  }

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay>? onTimePicked,
  }) async {
    final colors = context.colors;

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: colors.white,
              surface: colors.bgSecondary,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      onTimePicked?.call(picked);
    }
    return picked;
  }
}
