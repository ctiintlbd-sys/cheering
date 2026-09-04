import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/business_hours_bloc.dart';
import '../bloc/business_hours_event.dart';
import '../bloc/business_hours_state.dart';
import 'widgets/time_picker_row.dart';
import 'widgets/apply_to_weekdays_card.dart';
import '../../constants/business_hours_constants.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import '../../domain/entities/business_hours_entity.dart';

class EditBusinessHoursScreen extends StatefulWidget {
  final String dayKey;
  final Map<String, DayHoursEntity> editableDays;

  const EditBusinessHoursScreen({
    super.key,
    required this.dayKey,
    required this.editableDays,
  });

  @override
  State<EditBusinessHoursScreen> createState() =>
      _EditBusinessHoursScreenState();
}

class _EditBusinessHoursScreenState extends State<EditBusinessHoursScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BusinessHoursBloc>().add(
      InitEditBusinessHoursForm(
        dayKey: widget.dayKey,
        editableDays: widget.editableDays,
      ),
    );
  }

  void _onSave() {
    context.read<BusinessHoursBloc>().add(
      SaveEditBusinessHoursForm(dayKey: widget.dayKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayName =
        BusinessHoursConstants.fullDayNames[widget.dayKey] ?? 'Unknown';

    return BlocListener<BusinessHoursBloc, BusinessHoursState>(
      listenWhen: (prev, curr) => prev.updateStatus != curr.updateStatus,
      listener: (context, state) {
        if (state.updateStatus == BusinessHoursStatus.success) {
          context.pop(true);
        } else if (state.updateStatus == BusinessHoursStatus.failure) {
          ToastMessageHelper.show(
            state.errorMessage ?? 'Failed to update business hours',
          );
        }
      },
      child: SliverScaffold(
        backgroundColor: context.colors.background,
        appBar: CustomSliverAppBar(title: 'Edit hours'),
        bodyList: [
          SizedBox(height: 16.h),

          // ── 1. Day Heading ───────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: dayName,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                top: 2.h,
                text: 'Set when customers can order from you',
                color: context.colors.textSecondary,
              ),
            ],
          ).horizontal(16),

          SizedBox(height: 20.h),

          // ── 2. Open on this day Toggle Card ──────────────────────
          BlocBuilder<BusinessHoursBloc, BusinessHoursState>(
            buildWhen: (prev, curr) =>
                prev.editingDayHours?.isOpen != curr.editingDayHours?.isOpen,
            builder: (context, state) {
              final dayHours = state.editingDayHours;
              if (dayHours == null) return const SizedBox.shrink();

              return CustomContainer(
                horizontalMargin: 16.w,
                paddingAll: 16.r,
                radiusAll: 16.r,
                color: context.colors.bgSecondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Open on this day',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CupertinoSwitch(
                      value: dayHours.isOpen,
                      activeTrackColor: context.colors.success,
                      onChanged: (val) {
                        context.read<BusinessHoursBloc>().add(
                          UpdateEditBusinessHoursForm(
                            updatedDay: dayHours.copyWith(isOpen: val),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 20.h),

          // ── 3. Opens At & Closes At Pickers ──────────────────────
          BlocBuilder<BusinessHoursBloc, BusinessHoursState>(
            buildWhen: (prev, curr) =>
                prev.editingDayHours != curr.editingDayHours,
            builder: (context, state) {
              final dayHours = state.editingDayHours;
              if (dayHours == null || !dayHours.isOpen) {
                return SizedBox.shrink();
              }

              return TimePickerRow(
                opensAt: dayHours.opensAt,
                closesAt: dayHours.closesAt,
                onOpensAtChanged: (time) {
                  context.read<BusinessHoursBloc>().add(
                    UpdateEditBusinessHoursForm(
                      updatedDay: dayHours.copyWith(opensAt: time),
                    ),
                  );
                },
                onClosesAtChanged: (time) {
                  context.read<BusinessHoursBloc>().add(
                    UpdateEditBusinessHoursForm(
                      updatedDay: dayHours.copyWith(closesAt: time),
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 20.h),

          // ── 4. Apply to Weekdays Checkbox Card ───────────────────
          BlocSelector<BusinessHoursBloc, BusinessHoursState, bool>(
            selector: (state) => state.applyToWeekdays,
            builder: (context, applyToWeekdays) {
              return ApplyToWeekdaysCard(
                isApplied: applyToWeekdays,
                onChanged: (val) {
                  context.read<BusinessHoursBloc>().add(
                    UpdateEditBusinessHoursForm(
                      updatedDay: context
                          .read<BusinessHoursBloc>()
                          .state
                          .editingDayHours,
                      applyToWeekdays: val,
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 40.h),
        ],
        bottomNavigationBar:
            BlocSelector<BusinessHoursBloc, BusinessHoursState, bool>(
              selector: (state) =>
                  state.updateStatus == BusinessHoursStatus.loading,
              builder: (context, isLoading) {
                return CustomButton(
                  text: 'Save',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onSave,
                );
              },
            ),
      ),
    );
  }
}
