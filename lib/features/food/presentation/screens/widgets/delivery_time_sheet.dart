import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';

class TimeSlot {
  final DateTime dateTime;
  final String displayString;

  TimeSlot(this.dateTime, this.displayString);
}

class DeliveryTimeSheet extends StatefulWidget {
  final Map<String, BusinessHoursEntity> businessHours;

  const DeliveryTimeSheet({super.key, required this.businessHours});

  static Future<DateTime?> show(BuildContext context, Map<String, BusinessHoursEntity> businessHours) {
    return showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: context.colors.background,
      builder: (context) => DeliveryTimeSheet(businessHours: businessHours),
    );
  }

  @override
  State<DeliveryTimeSheet> createState() => _DeliveryTimeSheetState();
}

class _DeliveryTimeSheetState extends State<DeliveryTimeSheet> {
  final ValueNotifier<int> _selectedDateIndex = ValueNotifier<int>(0);
  final ValueNotifier<int> _selectedTimeIndex = ValueNotifier<int>(0);
  final ValueNotifier<List<TimeSlot>> _availableTimes = ValueNotifier<List<TimeSlot>>([]);

  final List<DateTime> _availableDates = [];
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: 0);
    _generateDates();
    if (_availableDates.isNotEmpty) {
      _generateTimesForDate(_availableDates[0]);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedDateIndex.dispose();
    _selectedTimeIndex.dispose();
    _availableTimes.dispose();
    super.dispose();
  }

  String _getWeekdayKey(int weekday) {
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

  void _generateDates() {
    _availableDates.clear();
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String key = _getWeekdayKey(date.weekday);
      if (widget.businessHours.containsKey(key)) {
        var hours = widget.businessHours[key]!;
        if (hours.isOpen) {
          _availableDates.add(date);
        }
      }
    }
  }

  void _generateTimesForDate(DateTime date) {
    List<TimeSlot> newTimes = [];
    String key = _getWeekdayKey(date.weekday);
    var hours = widget.businessHours[key];

    if (hours != null && hours.isOpen && hours.opensAt != null && hours.closesAt != null) {
      List<String> openParts = hours.opensAt!.split(':');
      List<String> closeParts = hours.closesAt!.split(':');

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

          String display = '${_formatTime(startTime)} - ${_formatTime(nextTime)}';
          newTimes.add(TimeSlot(startTime, display));
          startTime = nextTime;
        }
      }
    }

    _availableTimes.value = newTimes;
    _selectedTimeIndex.value = 0;
    if (_scrollController.hasClients) {
      _scrollController.jumpToItem(0);
    }
  }

  String _formatTime(DateTime time) {
    int h = time.hour;
    int m = time.minute;
    String ampm = h >= 12 ? 'PM' : 'AM';
    if (h > 12) h -= 12;
    if (h == 0) h = 12;
    return '$h:${m.toString().padLeft(2, '0')} $ampm';
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }

  String _getDayName(DateTime date) {
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

  @override
  Widget build(BuildContext context) {
    if (_availableDates.isEmpty) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(text: 'Scheduling not available', fontSize: 18.r, fontWeight: FontWeight.w700),
              SizedBox(height: 16.w),
              CustomButton(label: 'Close', onPressed: () => context.pop()),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.w,
          bottom: 10.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 48.w,
                height: 4.w,
                margin: EdgeInsets.only(bottom: 16.w),
                decoration: BoxDecoration(
                  color: context.colors.borderSecondary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            CustomText(
              text: 'Set your delivery time',
              fontSize: 18.r,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
            SizedBox(height: 8.w),
            CustomText(
              text: 'Standard delivery time will be added to your\nselected time',
              fontSize: 14.r,
              color: context.colors.textSecondary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.w),

            // Date Selector
            SizedBox(
              height: 60.w,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Divider(height: 1, thickness: 1, color: context.colors.borderSecondary),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _selectedDateIndex,
                    builder: (context, selectedIndex, child) {
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableDates.length,
                        separatorBuilder: (context, index) => SizedBox(width: 48.w),
                        itemBuilder: (context, index) {
                          final isSelected = index == selectedIndex;
                          final date = _availableDates[index];
                          return GestureDetector(
                            onTap: () {
                              _selectedDateIndex.value = index;
                              _generateTimesForDate(date);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected ? context.colors.primary : Colors.transparent,
                                    width: 2.w,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(bottom: 8.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: _formatDate(date),
                                    fontSize: 16.r,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textPrimary,
                                  ),
                                  SizedBox(height: 4.w),
                                  CustomText(
                                    text: _getDayName(date),
                                    fontSize: 14.r,
                                    color: context.colors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.w),

            // Time Selector
            SizedBox(
              height: 180.w,
              child: ValueListenableBuilder<List<TimeSlot>>(
                valueListenable: _availableTimes,
                builder: (context, times, child) {
                  if (times.isEmpty) {
                    return Center(child: CustomText(text: 'No time slots available for this day.', color: context.colors.textSecondary));
                  }
                  return ValueListenableBuilder<int>(
                    valueListenable: _selectedTimeIndex,
                    builder: (context, timeIndex, child) {
                      return ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: 50.w,
                        physics: const FixedExtentScrollPhysics(),
                        overAndUnderCenterOpacity: 0.3,
                        onSelectedItemChanged: (index) {
                          _selectedTimeIndex.value = index;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: times.length,
                          builder: (context, index) {
                            final isSelected = index == timeIndex;
                            return Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
                                decoration: BoxDecoration(
                                  color: isSelected ? context.colors.primary.withValues(alpha: 0.05) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: CustomText(
                                  text: times[index].displayString,
                                  fontSize: 16.r,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? context.colors.primary : context.colors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 24.w),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                label: 'Confirm',
                onPressed: () {
                  if (_availableTimes.value.isNotEmpty) {
                    context.pop(_availableTimes.value[_selectedTimeIndex.value].dateTime);
                  } else {
                    context.pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
