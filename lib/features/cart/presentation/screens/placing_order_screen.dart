import 'dart:async';

import 'package:cheering/core/common_widgets/striped_progress_painter.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_args.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_event.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_state.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PlacingOrderScreen extends StatefulWidget {
  const PlacingOrderScreen({super.key});

  @override
  State<PlacingOrderScreen> createState() => _PlacingOrderScreenState();
}

class _PlacingOrderScreenState extends State<PlacingOrderScreen> {
  Timer? _timer;
  int _secondsLeft = 5;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
        _placeOrder();
      }
    });
  }

  void _placeOrder() {
    context.read<CheckoutSummaryBloc>().add(const PlaceOrderEvent());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartBloc>().state.cart;
    final checkoutState = context.watch<CheckoutSummaryBloc>().state;
    final deliveryAddress =
        context.read<AddressBloc>().state.activeAddress?.formattedAddress ??
        'Delivery Address';

    return BlocListener<CheckoutSummaryBloc, CheckoutSummaryState>(
      listenWhen: (previous, current) =>
          previous.orderPlacedSuccess != current.orderPlacedSuccess ||
          previous.placeOrderErrorMessage != current.placeOrderErrorMessage,
      listener: (context, state) {
        if (state.orderPlacedSuccess) {
          context.go(
            RoutePaths.orderPlaced,
            extra: OrderPlacedArgs(
              restaurantName: state.placedRestaurantName ??
                  cart?.restaurantName ??
                  'Restaurant',
              estimatedDeliveryMinutes:
                  state.summary?.estimatedDeliveryMinutes ?? 0,
              orderId: state.placedOrderId ?? '—',
            ),
          );
        } else if (state.placeOrderErrorMessage != null) {
          ToastMessageHelper.show(state.placeOrderErrorMessage ?? '');
        }
      },
      child: SliverScaffold(
        sideContentPadding: 16.w,
        appBar: CustomSliverAppBar(
          toolbarHeight: 0,
          expandedHeight: kToolbarHeight,
          flexibleChild: SizedBox.shrink(),
        ),
        bodyList: [
          Assets.images.placingOrder.image(width: 284.w, height: 176.w),
          SizedBox(height: 24.h),
          CustomText(
            text: 'Placing your Order...',
            fontSize: 24.r,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          StripedProgressPainter(),
          SizedBox(height: 12.h),
          CustomText(
            text:
                "Please wait a moment while we confirm your order This won't take long",
            color: context.colors.textTertiary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28.h),
          OrderDetailsCard(
            restaurantName: cart?.restaurantName ?? 'Restaurant',
            deliveryAddress: deliveryAddress,
            items: cart?.items ?? const [],
            paymentMethod: checkoutState.paymentMethod,
          ),
          SizedBox(height: 28.h),
          CustomButton(
            text: checkoutState.isPlacingOrder ? 'Placing...' : 'Looks Good',
            isLoading: checkoutState.isPlacingOrder,
            onPressed: checkoutState.isPlacingOrder
                ? null
                : () {
                    _timer?.cancel();
                    _placeOrder();
                  },
          ),
          SizedBox(height: 12.h),
          CustomButton(
            text: 'Modify(00:0$_secondsLeft)',
            backgroundColor: Colors.transparent,
            textColor: context.colors.textPrimary,
            bordersColor: context.colors.borderPrimary,
            onPressed: checkoutState.isPlacingOrder
                ? null
                : () {
                    _timer?.cancel();
                    context.pop();
                  },
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
