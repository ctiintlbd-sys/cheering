import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/presentation/blocs/order_details/order_details_bloc.dart';
import 'package:cheering/features/orders/presentation/blocs/order_details/order_details_state.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_details_bill_card.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_details_delivery_card.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_details_items_card.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_details_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        final order = state.orderDetails;
        return SliverScaffold(
          backgroundColor: context.colors.bgSecondary,
          sideContentPadding: 16.w,
          appBar: CustomSliverAppBar(
            title: 'Order Details',
            backgroundColor: context.colors.bgSecondary.withValues(alpha: 0.8),
          ),

          bodyList: switch (state.status) {
            OrderDetailsStatus.initial ||
            OrderDetailsStatus.loading => [const OrderDetailsLoadingWidget()],
            OrderDetailsStatus.failure => [
              EmptyState(message: state.errorMessage ?? ''),
            ],
            OrderDetailsStatus.success when order == null => [
              const EmptyState(message: 'Unable to load order'),
            ],
            OrderDetailsStatus.success => [
              SizedBox(height: 16.w),
              OrderDetailsItemsCard(order: order!),
              SizedBox(height: 20.w),
              OrderDetailsDeliveryCard(
                address: order.deliveryAddressText,
                paymentMethod: order.paymentMethod,
              ),
              SizedBox(height: 20.w),
              OrderDetailsBillCard(order: order),
              SizedBox(height: 144.w),
            ],
          },

          bottomNavigationBar: order == null
              ? null
              : order.status == 'DELIVERED'
              ? Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Rate Order',
                        backgroundColor: Colors.transparent,
                        bordersColor: context.colors.borderSecondary,
                        textColor: context.colors.textPrimary,
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomButton(
                        label: 'Order Again',
                        onPressed: order.restaurantId.isEmpty
                            ? null
                            : () => context.push(
                                RoutePaths.storeDetails(order.restaurantId),
                              ),
                      ),
                    ),
                  ],
                )
              : CustomButton(
                  label: 'Track Order',
                  onPressed: () => context.push(RoutePaths.tracking(order.id)),
                ),
        );
      },
    );
  }
}
