import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/widgets/widgets.dart';

class DeliveryTimeSheet extends StatefulWidget {
  const DeliveryTimeSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: context.colors.background,
      builder: (context) => const DeliveryTimeSheet(),
    );
  }

  @override
  State<DeliveryTimeSheet> createState() => _DeliveryTimeSheetState();
}

class _DeliveryTimeSheetState extends State<DeliveryTimeSheet> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 1;

  final List<String> dates = ['08 Aug', '09 Aug', '10 Aug', '11 Aug'];
  final List<String> days = ['Today', 'Tomorrow', 'Mon', 'Tue'];

  final List<String> times = [
    '2:00 PM - 2:10 PM',
    '2:40 PM - 2:50 PM',
    '3:00 PM - 3:10 PM',
    '3:20 PM - 3:30 PM',
    '3:40 PM - 3:50 PM',
  ];

  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedTimeIndex,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.w,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
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
              text:
                  'Standard delivery time will be added to your\nselected time',
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
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: context.colors.borderSecondary,
                    ),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    separatorBuilder: (context, index) => SizedBox(width: 48.w),
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedDateIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDateIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? context.colors.primary
                                    : Colors.transparent,
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
                                text: dates[index],
                                fontSize: 16.r,
                                fontWeight: FontWeight.w600,
                                color: context.colors.textPrimary,
                              ),
                              SizedBox(height: 4.w),
                              CustomText(
                                text: days[index],
                                fontSize: 14.r,
                                color: isSelected
                                    ? context.colors.textSecondary
                                    : context.colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
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
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 50.w,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.3,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedTimeIndex = index;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: times.length,
                  builder: (context, index) {
                    final isSelected = index == _selectedTimeIndex;
                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.w,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.colors.primary.withValues(alpha: 0.05)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: CustomText(
                          text: times[index],
                          fontSize: 16.r,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 24.w),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                label: 'Confirm',
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
