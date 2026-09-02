import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/helpers/date_picker_helper.dart';
import 'package:cheering/core/utils/app_date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';
import 'widgets/report_shimmer.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  void _onPickFromDate(BuildContext context, DateTime currentDate) async {
    final picked = await context.pickDate(initialDate: currentDate);
    if (!context.mounted) return;
    if (picked != null) {
      context.read<OverviewBloc>().add(UpdateReportDateRange(fromDate: picked));
    }
  }

  void _onPickToDate(BuildContext context, DateTime currentDate) async {
    final picked = await context.pickDate(initialDate: currentDate);
    if (!context.mounted) return;
    if (picked != null) {
      context.read<OverviewBloc>().add(UpdateReportDateRange(toDate: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(title: 'Report'),
      bodyList: [
        SizedBox(height: 16.h).asSliver,

        // ── 1. From Date & To Date Pickers ───────────────────────
        BlocBuilder<OverviewBloc, OverviewState>(
          buildWhen: (prev, curr) => prev.reportFromDate != curr.reportFromDate,
          builder: (context, state) {
            return CustomTextField(
              controller: TextEditingController(
                text: state.reportFromDate != null
                    ? AppDateFormatter.formatDayMonthYear(state.reportFromDate!)
                    : '',
              ),
              readOnly: true,
              labelText: 'From Date',
              suffixIcon: Assets.icons.date.svg(height: 24.r, width: 24.r),
              onTap: () {
                if (state.reportFromDate != null) {
                  _onPickFromDate(context, state.reportFromDate!);
                }
              },
            );
          },
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 12.h).asSliver,

        BlocBuilder<OverviewBloc, OverviewState>(
          buildWhen: (prev, curr) => prev.reportToDate != curr.reportToDate,
          builder: (context, state) {
            return CustomTextField(
              controller: TextEditingController(
                text: state.reportToDate != null
                    ? AppDateFormatter.formatDayMonthYear(state.reportToDate!)
                    : '',
              ),
              readOnly: true,
              labelText: 'To Date',
              suffixIcon: Assets.icons.date.svg(height: 24.r, width: 24.r),
              onTap: () {
                if (state.reportToDate != null) {
                  _onPickToDate(context, state.reportToDate!);
                }
              },
            );
          },
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 20.h).asSliver,

        // ── 3. Report Stats ───────────────────────────────────────
        SliverToBoxAdapter(
          child: BlocBuilder<OverviewBloc, OverviewState>(
            buildWhen: (prev, curr) =>
                prev.reportStatus != curr.reportStatus ||
                prev.report != curr.report,
            builder: (context, state) {
              switch (state.reportStatus) {
                case ReportStatus.initial:
                case ReportStatus.loading:
                  return const ReportShimmer();
                case ReportStatus.failure:
                  return EmptyState(
                    message:
                        state.reportErrorMessage ?? 'Failed to load report',
                  );
                case ReportStatus.success:
                  if (state.report == null) {
                    return SizedBox.shrink();
                  }

                  final report = state.report!;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildReportCard(
                                context,
                                title: 'Order complete',
                                value: report.orders.toString(),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildReportCard(
                                context,
                                title: 'Food Bill',
                                value:
                                    '৳${report.grossSales.toStringAsFixed(0)}',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildReportCard(
                                context,
                                title: 'Commission',
                                value:
                                    '৳${report.commission.toStringAsFixed(0)}',
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildReportCard(
                                context,
                                title: 'Total earning',
                                value:
                                    '৳${report.netPayout.toStringAsFixed(0)}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ),

        SizedBox(height: 40.h).asSliver,
      ],
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return CustomContainer(
      paddingAll: 16.r,
      radiusAll: 16.r,
      color: context.colors.bgTertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title, color: context.colors.textSecondary),
          SizedBox(height: 8.h),
          CustomText(text: value, fontSize: 24.sp, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}
