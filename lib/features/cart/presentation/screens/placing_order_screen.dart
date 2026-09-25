import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/cart/presentation/blocs/cart/cart_bloc.dart';
import '../../../../features/cart/presentation/blocs/checkout_summary/checkout_summary_bloc.dart';
import '../../../../features/cart/presentation/blocs/checkout_summary/checkout_summary_event.dart';
import '../../../../features/cart/presentation/blocs/checkout_summary/checkout_summary_state.dart';
import '../../../../core/router/route_paths.dart';
import 'package:cheering/core/common_widgets/striped_progress_painter.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
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
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
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
    final cartState = context.read<CartBloc>().state;
    final checkoutState = context.watch<CheckoutSummaryBloc>().state;

    // Extracting data for OrderDetailsCard
    final restaurantName = cartState.cart?.restaurantName ?? 'Unknown Restaurant';
    // Ideally you'd get the actual address text from address bloc or summary state. 
    // Assuming summary holds the addressId for now, we put a placeholder or you can pass it in via route.
    final deliveryAddress = 'Delivery Address';
    final itemCount = cartState.cart?.items.length ?? 0;
    final mainItemName = itemCount > 0 ? cartState.cart!.items.first.name : 'Items';
    final paymentMethod = checkoutState.paymentMethod == 'COD' ? 'Cash on delivery' : checkoutState.paymentMethod;

    return BlocListener<CheckoutSummaryBloc, CheckoutSummaryState>(
      listenWhen: (previous, current) => previous.orderPlacedSuccess != current.orderPlacedSuccess,
      listener: (context, state) {
        if (state.orderPlacedSuccess) {
          context.go(RoutePaths.orderPlaced);
        } else if (state.placeOrderErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.placeOrderErrorMessage!)),
          );
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
            restaurantName: restaurantName,
            deliveryAddress: deliveryAddress,
            itemCount: itemCount,
            mainItemName: mainItemName,
            paymentMethod: paymentMethod,
          ),
          SizedBox(height: 28.h),
          CustomButton(
            text: checkoutState.isPlacingOrder ? 'Placing...' : 'Looks Good',
            isLoading: checkoutState.isPlacingOrder,
            onPressed: () {
              if (!checkoutState.isPlacingOrder) {
                _timer?.cancel();
                _placeOrder();
              }
            },
          ),
          SizedBox(height: 12.h),
          CustomButton(
            text: 'Modify(00:0$_secondsLeft)',
            backgroundColor: Colors.transparent,
            textColor: context.colors.textPrimary,
            bordersColor: context.colors.borderPrimary,
            onPressed: checkoutState.isPlacingOrder ? null : () {
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


class _AnimatedStripedProgressPainter extends CustomPainter {
  final Color stripeColor;
  final double progress;

  const _AnimatedStripedProgressPainter({
    required this.stripeColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Strictly clip to rounded bounds
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(6),
      ),
    );

    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const spacing = 12.0;
    final offset = progress * spacing;
    final totalWidth = size.width + size.height * 2;

    for (double x = -size.height * 2 + offset; x < totalWidth; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x - 10, size.height), paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AnimatedStripedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.stripeColor != stripeColor;
  }
}

