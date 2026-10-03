import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_state.dart';
import 'package:cheering/features/address/presentation/screens/widgets/add_address_location_card.dart';
import 'package:cheering/features/cart/domain/entities/checkout_summary_params.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_event.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_state.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/bill_details_card.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/cart_botton_bar_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/delivery_or_tip_section.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/payment_methods_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (previous, current) =>
          previous.activeDefaultId != current.activeDefaultId,
      listener: (context, state) {
        if (state.activeDefaultId != null) {
          context.read<CheckoutSummaryBloc>().add(
            LoadCheckoutSummary(
              CheckoutSummaryParams(addressId: state.activeDefaultId!),
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutSummaryBloc, CheckoutSummaryState>(
        builder: (context, state) {
          return SliverScaffold(
            isNavWrap: false,
            backgroundColor: context.colors.bgSecondary,
            appBar: CustomSliverAppBar(
              backgroundColor: context.colors.bgSecondary,
              title: 'Checkout',
            ),
            bottomNavigationBar:  CartBottomBarWidget(
              errorText: state.errorMessage,
              totalPrice: state.summary?.grandTotal ?? 0,
              buttonText: 'Place order',
              onPressed: () {
                context.pushReplacement(
                  RoutePaths.placingOrder,
                  extra: context.read<CheckoutSummaryBloc>(),
                );
              },
            ),
            bodyList: [
              SizedBox(height: 16.w),
              BlocBuilder<AddressBloc, AddressState>(
                builder: (context, addressState) {
                  return AddAddressLocationCard(
                    color: context.colors.white,
                    address: addressState.activeAddress,
                    onChangeTap: () {
                      context.push(RoutePaths.address);
                    },
                  ).horizontal(16.w);
                },
              ),
              SizedBox(height: 20.w),

              CustomText(
                left: 16.w,
                text: 'Payment method',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.w),
              PaymentMethodsCard(
                selectedValue: state.paymentMethod,
                onChanged: (value) => context.read<CheckoutSummaryBloc>().add(
                  UpdatePaymentMethodEvent(value),
                ),
              ),
              SizedBox(height: 20.w),
              DeliveryOrTipSection(
                deliveryOptions: state.summary?.deliveryOptions ?? [],
                selectedTip: state.currentParams?.tip ?? 0.0,
                onTipSelected: (tip) {
                  context.read<CheckoutSummaryBloc>().add(UpdateTipEvent(tip));
                },
                selectedDeliveryType: state.currentParams?.deliveryType ??
                    state.summary?.deliveryType,
                onDeliveryOptionSelected: (option) {
                  context
                      .read<CheckoutSummaryBloc>()
                      .add(UpdateDeliveryTypeEvent(option.type));
                },
              ),
              SizedBox(height: 20.w),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return BillDetailsCard(
                    itemTotal: state.summary?.itemTotal ?? 0,
                    itemCount: cartState.cart?.itemCount ?? 0,
                    minOrderAmount: cartState.cart?.minOrderAmount ?? 0,
                    deliveryFee: state.summary?.deliveryFee,
                    priorityFee: state.summary?.priorityFee,
                    platformFee: state.summary?.platformFee,
                    discount: state.summary?.discount,
                    tip: state.summary?.tip,
                    grandTotal: state.summary?.grandTotal,
                  );
                },
              ),
              SizedBox(height: 204.w),
            ],
          );
        },
      ),
    );
  }
}
