import 'dart:async';
import 'package:cheering/core/models/weekly_chart_item.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends StatefulWidget {
  final List<WeeklyChartItem> weeklyStats;
  final String title;

  const WeeklyChart({
    super.key,
    required this.weeklyStats,
    this.title = 'LAST 7 DAYS',
  });

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  final ValueNotifier<int?> _selectedIndexNotifier = ValueNotifier<int?>(null);
  Timer? _dismissTimer;

  // Static formatters — created once, reused across all instances & rebuilds.
  static final DateFormat _bannerDateFormat = DateFormat('d MMM (E)');
  static final DateFormat _dayFormat = DateFormat('E');
  static final NumberFormat _currencyFormat = NumberFormat('#,##0', 'en_US');

  // Pre-computed in initState / didUpdateWidget — never recomputed in build().
  late List<WeeklyChartItem> _displayStats;
  late double _effectiveMax;

  // Cached border radius — same value used for every bar, built once.
  static final BorderRadius _barRadius = BorderRadius.vertical(
    top: Radius.circular(8.r),
  );

  @override
  void initState() {
    super.initState();
    _computeDisplayData();
  }

  @override
  void didUpdateWidget(covariant WeeklyChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // identity check is O(1) — avoids recompute when parent rebuilds with
    // the same list reference.
    if (!identical(oldWidget.weeklyStats, widget.weeklyStats)) {
      _computeDisplayData();
    }
  }

  /// Builds [_displayStats] and [_effectiveMax] from the current widget data.
  /// Falls back to a 7-day zero-value placeholder series when the list is
  /// empty, so the chart shell always renders.
  void _computeDisplayData() {
    if (widget.weeklyStats.isNotEmpty) {
      _displayStats = widget.weeklyStats;
      double max = 100.0;
      for (final stat in widget.weeklyStats) {
        if (stat.value > max) max = stat.value;
      }
      _effectiveMax = max == 0 ? 100.0 : max;
    } else {
      final now = DateTime.now();
      _displayStats = List<WeeklyChartItem>.generate(7, (i) {
        final date = now.subtract(Duration(days: 6 - i));
        return WeeklyChartItem(
          day: _dayFormat.format(date).substring(0, 3).toUpperCase(),
          date: date.toIso8601String(),
          value: 0,
          earnings: 0,
          orders: 0,
          isHighlighted: false,
        );
      });
      _effectiveMax = 100.0;
    }
  }

  void _onBarTap(int index) {
    _dismissTimer?.cancel();
    _selectedIndexNotifier.value = index;
    _dismissTimer = Timer(const Duration(seconds: 5), () {
      _selectedIndexNotifier.value = null;
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _selectedIndexNotifier.dispose();
    super.dispose();
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      return _bannerDateFormat.format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  // ── Info Banner (Stack overlay, top-right of chart) ──────────────────────
  Widget _buildInfoBanner(BuildContext context, WeeklyChartItem stat) {
    return Container(
      key: ValueKey(stat.date),
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.colors.borderSecondary, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: dot + date ───────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.colors.borderSecondary,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                CustomText(
                  text: _formatDate(stat.date),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),

          // ── Bottom: earnings + orders ─────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: '৳${_currencyFormat.format(stat.earnings.toInt())}',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
                SizedBox(width: 8.w),
                CustomText(
                  text: '${stat.orders} ord',
                  fontSize: 11.sp,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Single bar item — extracted to keep build() readable ─────────────────
  Widget _buildBar(
      BuildContext context,
      int index,
      WeeklyChartItem stat,
      double barHeight,
      ) {
    final isLast = index == _displayStats.length - 1;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onBarTap(index),
        child: Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 10.w),
          child: ValueListenableBuilder<int?>(
            valueListenable: _selectedIndexNotifier,
            builder: (context, selectedIndex, _) {
              final isSelected = selectedIndex == index;
              final hasSelection = selectedIndex != null;

              final Color barColor;
              if (hasSelection) {
                barColor = isSelected
                    ? context.colors.primary
                    : context.colors.primary.withValues(alpha: 0.15);
              } else {
                barColor = stat.isHighlighted
                    ? context.colors.primary
                    : context.colors.primary.withValues(alpha: 0.2);
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: _barRadius,
                      border: isSelected
                          ? Border.all(
                        color: context.colors.primary,
                        width: 1.5,
                      )
                          : null,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: stat.day,
                    fontSize: 11.sp,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.textTertiary,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartHeight = 115.h;

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Section Title ─────────────────────────────────────
          CustomText(
            text: widget.title.toUpperCase(),
            color: context.colors.textTertiary,
          ),
          SizedBox(height: 10.h),

          // ── Stack: bars + floating overlay banner ─────────────
          Stack(
            children: [
              // Bars
              SizedBox(
                height: chartHeight + 24.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < _displayStats.length; i++)
                      _buildBar(
                        context,
                        i,
                        _displayStats[i],
                        chartHeight *
                            (_displayStats[i].value / _effectiveMax)
                                .clamp(0.2, 1.0),
                      ),
                  ],
                ),
              ),

              // Floating info banner — top-right, above bars
              Positioned(
                top: 0,
                right: 0,
                child: ValueListenableBuilder<int?>(
                  valueListenable: _selectedIndexNotifier,
                  builder: (context, selectedIndex, _) {
                    final selectedStat =
                    selectedIndex != null &&
                        selectedIndex < _displayStats.length
                        ? _displayStats[selectedIndex]
                        : null;

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: selectedStat != null
                          ? _buildInfoBanner(context, selectedStat)
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}