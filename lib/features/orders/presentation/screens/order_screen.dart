import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/get_orders_params.dart';
import 'package:cheering/features/orders/presentation/blocs/order_list/order_list_bloc.dart';
import 'package:cheering/features/orders/presentation/blocs/order_list/order_list_event.dart';
import 'package:cheering/features/orders/presentation/blocs/order_list/order_list_state.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_card.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_empty_state.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_loading_widget.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/order_status_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        return SliverScaffold(
          onRefresh: () async {
            final params =
                context.read<OrderListBloc>().state.currentParams ??
                const GetOrdersParams();
            context.read<OrderListBloc>().add(RefreshOrders(params: params));
          },
          appBar: CustomSliverAppBar(
            toolbarHeight: 18.w,
            flexibleChild: CustomText(
              text: 'Order',
              fontSize: 18.r,
              fontWeight: FontWeight.w600,
            ),
            expandedHeight: 108.w,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(44.w),
              child: const OrderStatusTabs(),
            ),
          ),
          bodyList: switch (state.status) {
            OrderListStatus.initial ||
            OrderListStatus.loading => [const OrderLoadingWidget()],
            OrderListStatus.failure => [
              EmptyState(message: state.errorMessage ?? 'No orders'),
            ],
            OrderListStatus.success when state.orders.isEmpty => [
              const EmptyState(message: 'No orders found yet.'),
            ],
            OrderListStatus.success => [
              SizedBox(height: 16.w),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList.separated(
                  itemCount: state.orders.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.w),
                  itemBuilder: (context, index) {
                    return CustomItemAnimator(
                      index: index,
                      child: OrderCard(order: state.orders[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 120.w),
            ],
          },
        );
      },
    );
  }
}
