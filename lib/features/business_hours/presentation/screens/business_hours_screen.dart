import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/business_hours/presentation/screens/widgets/day_schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import '../bloc/business_hours_bloc.dart';
import '../bloc/business_hours_event.dart';
import '../bloc/business_hours_state.dart';
import 'widgets/business_hours_shimmer.dart';
import '../../constants/business_hours_constants.dart';
import '../../domain/entities/business_hours_entity.dart';

class BusinessHoursScreen extends StatelessWidget {
  const BusinessHoursScreen({super.key});

  void _editDaySchedule(BuildContext context, String dayKey, Map<String, DayHoursEntity> editableDays) async {
    final isUpdated = await context.push(
      RoutePaths.editBusinessHours,
      extra: {
        'dayKey': dayKey,
        'editableDays': editableDays,
      },
    );
    if (context.mounted && isUpdated == true) {
      context.read<BusinessHoursBloc>().add(const LoadBusinessHours());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessHoursBloc, BusinessHoursState>(
      listenWhen: (prev, curr) => prev.updateStatus != curr.updateStatus,
      listener: (context, state) {
        if (state.updateStatus == BusinessHoursStatus.failure) {
          ToastMessageHelper.show(
            state.errorMessage ?? 'Failed to update business hours',
          );
        }
      },
      builder: (context, state) {
        return SliverScaffold(
          backgroundColor: context.colors.background,
          appBar: CustomSliverAppBar(title: 'Business Hours'),
          bodyList: [
            SizedBox(height: 16.h),

            switch (state.fetchStatus) {
              BusinessHoursStatus.initial ||
              BusinessHoursStatus.loading => const BusinessHoursShimmer(),
              BusinessHoursStatus.failure => EmptyState(
                message: state.errorMessage ?? 'Failed to load business hours',
              ),
              BusinessHoursStatus.success => SliverList.builder(
                itemCount: BusinessHoursConstants.shortDayNames.length,
                itemBuilder: (context, index) {
                  final entry = BusinessHoursConstants.shortDayNames.entries.elementAt(index);
                  final dayKey = entry.key;
                  final dayLabel = entry.value;
                  final dayHours = state.editableDays![dayKey];

                  if (dayHours == null) {
                    return const SizedBox.shrink();
                  }

                  return DayScheduleItem(
                    dayLabel: dayLabel,
                    dayHours: dayHours,
                    onTap: () => _editDaySchedule(context, dayKey, state.editableDays!),
                    onToggle: (val) {
                      if (val == true) {
                        _editDaySchedule(context, dayKey, state.editableDays!);
                      } else {
                        final updatedDay = dayHours.copyWith(isOpen: false);
                        context.read<BusinessHoursBloc>().add(
                          EditDayHoursEvent(
                            dayKey: dayKey,
                            updatedDay: updatedDay,
                          ),
                        );
                        context.read<BusinessHoursBloc>().add(
                          const UpdateBusinessHours(),
                        );
                      }
                    },
                  );
                },
              ),
            },

            SizedBox(height: 100.h),
          ],
        );
      },
    );
  }
}
