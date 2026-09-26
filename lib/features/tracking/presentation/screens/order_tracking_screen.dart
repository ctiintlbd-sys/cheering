import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/order_tracking_entity.dart';
import '../blocs/order_tracking/order_tracking_bloc.dart';
import '../blocs/order_tracking/order_tracking_event.dart';
import '../blocs/order_tracking/order_tracking_state.dart';
import 'widgets/tracking_status_header.dart';
import 'widgets/tracking_timeline.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      builder: (context, state) {
        return SliverScaffold(
          sideContentPadding: 16.w,
          appBar:  CustomSliverAppBar(
            backgroundColor: context.colors.background.withValues(alpha: 0),
          ),
          bodyList: [
            ...switch (state.status) {
              OrderTrackingStatus.initial ||
              OrderTrackingStatus.loading => [
                  SizedBox(height: 160.w),
                  const Center(child: CircularProgressIndicator()),
                ],
              OrderTrackingStatus.failure => [
                  SizedBox(height: 80.w),
                  CustomText(
                    text: state.errorMessage ?? 'Unable to load tracking',
                    color: context.colors.textTertiary,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.w),
                  CustomButton(
                    label: 'Try again',
                    onPressed: () {
                      context
                          .read<OrderTrackingBloc>()
                          .add(LoadOrderTracking(orderId));
                    },
                  ),
                ],
              OrderTrackingStatus.success when state.tracking == null => [
                  SizedBox(height: 80.w),
                  CustomText(
                    text: 'Unable to load tracking',
                    color: context.colors.textTertiary,
                    textAlign: TextAlign.center,
                  ),
                ],
              OrderTrackingStatus.success =>
                _successBody(context, state.tracking!),
            },
          ],
        );
      },
    );
  }

  List<Widget> _successBody(BuildContext context, OrderTrackingEntity tracking) {
    return [
      TrackingStatusHeader(tracking: tracking),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: 'My Order',
            fontSize: 18.r,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            text: 'Details',
            color: context.colors.textTertiary,
          ),
        ],
      ),
      SizedBox(height: 16.w),
      TrackingTimeline(tracking: tracking),
      SizedBox(height: 40.w),
    ];
  }
}
