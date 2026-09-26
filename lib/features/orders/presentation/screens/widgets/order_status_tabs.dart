import 'package:cheering/core/common_widgets/custom_filter_chip.dart';
import 'package:cheering/features/orders/domain/entities/get_orders_params.dart';
import 'package:cheering/features/orders/presentation/blocs/order_list/order_list_bloc.dart';
import 'package:cheering/features/orders/presentation/blocs/order_list/order_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/order_list/order_list_state.dart';

class _OrderTab {
  final String label;
  final String? filter;

  const _OrderTab(this.label, this.filter);
}

const _tabs = [
  _OrderTab('All', null),
  _OrderTab('Ongoing', 'ACTIVE'),
  _OrderTab('Delivered', 'DELIVERED'),
  _OrderTab('Cancelled', 'CANCELLED'),
];

class OrderStatusTabs extends StatelessWidget {
  const OrderStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderListBloc, OrderListState>(
      buildWhen: (previous, current) =>
          previous.currentParams?.statusFilter !=
          current.currentParams?.statusFilter,
      builder: (context, state) {
        final selected = state.currentParams?.statusFilter;

        return SizedBox(
          height: 44.w,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            separatorBuilder: (_, _) => SizedBox(width: 6.w),
            itemBuilder: (context, index) {
              final tab = _tabs[index];

              return CustomFilterChip(
                label: tab.label,
                isSelected: tab.filter == selected,
                onTap: () {
                  context.read<OrderListBloc>().add(
                    LoadOrders(params: GetOrdersParams(statusFilter: tab.filter)),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
