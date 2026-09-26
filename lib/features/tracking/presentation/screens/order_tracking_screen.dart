import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_loading_widget.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_status_header.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../blocs/order_tracking/order_tracking_bloc.dart';
import '../blocs/order_tracking/order_tracking_event.dart';
import '../blocs/order_tracking/order_tracking_state.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      builder: (context, state) {
        return SliverScaffold(
          sideContentPadding: 16.w,
          onRefresh: () async {
            context.read<OrderTrackingBloc>().add(LoadOrderTracking(orderId));
          },
          appBar: CustomSliverAppBar(
            backgroundColor: context.colors.background.withValues(alpha: 0),
          ),
          bodyList: switch (state.status) {
            OrderTrackingStatus.initial ||
            OrderTrackingStatus.loading => [const TrackingLoadingWidget()],
            OrderTrackingStatus.failure => [
              EmptyState(message: state.errorMessage ?? ''),
            ],
            OrderTrackingStatus.success when state.tracking == null => [
              EmptyState(message: state.errorMessage ?? ''),
            ],
            OrderTrackingStatus.success => [
              TrackingStatusHeader(tracking: state.tracking!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'My Order',
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: 'Details',
                    fontSize: 12.w,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textTertiary,
                    onTap: () => context.push(RoutePaths.details(orderId)),
                  ),
                ],
              ),
              SizedBox(height: 16.w),
              TrackingTimeline(tracking: state.tracking!),
              SizedBox(height: 40.w),
            ],
          },
        );
      },
    );
  }
}
